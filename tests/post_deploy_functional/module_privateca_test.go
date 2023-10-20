package test

import (
	"context"
	"fmt"
	"os"
	"reflect"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/acmpca"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

const (
	base            = "../../examples/"
	testVarFileName = "/test.tfvars"
)

var standardTags = map[string]string{
	"provisioner": "Terraform",
}

func TestPrivateCA(t *testing.T) {
	t.Parallel()
	stage := test_structure.RunTestStage

	files, err := os.ReadDir(base)
	if err != nil {
		assert.Error(t, err)
	}
	for _, file := range files {
		dir := base + file.Name()
		if file.IsDir() {
			defer stage(t, "teardown_ca", func() { tearDownCA(t, dir) })
			stage(t, "setup_and_test_ca", func() { setupAndTestCA(t, dir) })
		}
	}
}

func setupAndTestCA(t *testing.T, dir string) {

	terraformOptions := &terraform.Options{
		TerraformDir: dir,
		VarFiles:     []string{dir + testVarFileName},
		NoColor:      true,
		Logger:       logger.Discard,
	}

	expectedPatternCAID := "^arn:aws:acm-pca:[a-z0-9-]+:[0-9]{12}:certificate-authority/.+$"
	expectedPatternARN := "^arn:aws:acm-pca:[a-z0-9-]+:[0-9]{12}:certificate-authority/.+$"

	test_structure.SaveTerraformOptions(t, dir, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	actualId := terraform.Output(t, terraformOptions, "private_ca_id")
	assert.NotEmpty(t, actualId, "private CA ID is empty")
	assert.Regexp(t, expectedPatternCAID, actualId, "CAID does not match expected pattern")
	actualARN := terraform.Output(t, terraformOptions, "private_ca_arn")
	assert.Regexp(t, expectedPatternARN, actualARN, "ARN does not match expected pattern")

	cfg, err := config.LoadDefaultConfig(
		context.TODO(),
		config.WithSharedConfigProfile(os.Getenv("AWS_PROFILE")),
	)
	if err != nil {
		assert.Error(t, err, "can't connect to aws")
	}

	client := acmpca.NewFromConfig(cfg)

	input := &acmpca.DescribeCertificateAuthorityInput{
		CertificateAuthorityArn: aws.String(actualARN),
	}

	result, err := client.DescribeCertificateAuthority(context.TODO(), input)
	if err != nil {
		assert.Error(t, err, "The expected CA was not found")
	}

	ca := result.CertificateAuthority

	expectedType, err := terraform.GetVariableAsStringFromVarFileE(t, dir+testVarFileName, "type")
	assert.NoError(t, err)
	actualType := string(ca.Type)
	assert.Equal(t, expectedType, actualType, "CA Type does not match")

	expectedKeyAlgorithm, err := terraform.GetVariableAsStringFromVarFileE(t, dir+testVarFileName, "key_algorithm")
	assert.NoError(t, err)
	actualKeyAlgorithm := string(ca.CertificateAuthorityConfiguration.KeyAlgorithm)
	assert.Equal(t, expectedKeyAlgorithm, actualKeyAlgorithm, "Key Algorithm does not match")

	expectedSigningAlgorithm, err := terraform.GetVariableAsStringFromVarFileE(t, dir+testVarFileName, "signing_algorithm")
	assert.NoError(t, err)
	actualSigningAlgorithm := string(ca.CertificateAuthorityConfiguration.SigningAlgorithm)
	assert.Equal(t, expectedSigningAlgorithm, actualSigningAlgorithm, "Signing Algorithm does not match")

	expectedName, err := terraform.GetVariableAsStringFromVarFileE(t, dir+testVarFileName, "name") //"demopca-53453-..."
	if err == nil {
		actualName := terraform.Output(t, terraformOptions, "resource_name_tag")
		assert.True(t, strings.HasPrefix(actualName, expectedName), actualName, "Name did not match expected")
	}

	checkTagsMatch(t, dir, actualARN, client)
}

// checkTagsMatch validates if the actual tags match the expected tags
func checkTagsMatch(t *testing.T, dir string, actualARN string, client *acmpca.Client) {
	expectedTags, err := terraform.GetVariableAsMapFromVarFileE(t, dir+testVarFileName, "tags")
	if err == nil {
		result2, err2 := client.ListTags(context.TODO(), &acmpca.ListTagsInput{CertificateAuthorityArn: aws.String(actualARN)})
		if err2 != nil {
			assert.Error(t, err2, "Failed to retrieve tags from AWS")
		}
		// convert AWS Tag[] to map so we can compare
		actualTags := map[string]string{}
		for _, tag := range result2.Tags {
			actualTags[*tag.Key] = *tag.Value
		}

		// add the standard tags and the resource_name tag to the expected tags
		for k, v := range standardTags {
			expectedTags[k] = v
		}
		expectedTags["resource_name"] = actualTags["resource_name"]
		assert.True(t, reflect.DeepEqual(actualTags, expectedTags), fmt.Sprintf("tags did not match, expected: %v\nactual: %v", expectedTags, actualTags))
	}
}

func tearDownCA(t *testing.T, dir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, dir)
	terraformOptions.Logger = logger.Discard
	terraform.Destroy(t, terraformOptions)
}
