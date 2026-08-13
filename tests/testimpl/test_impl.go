package common

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/acmpca"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

// TestDoesCaExist is the functional entrypoint's implementation function, run
// via lib.RunSetupTestTeardown (apply -> test -> destroy).
func TestDoesCaExist(t *testing.T, ctx types.TestContext) {
	checkCaExists(t, ctx)
}

// TestComposableCompleteReadOnly is the readonly entrypoint's implementation
// function. lcaf-component-terratest requires readonly implementation
// functions to be named with a TestComposable prefix, and it is run via
// lib.RunNonDestructiveTest against already-deployed infrastructure. It
// performs the same read-only assertions as the functional suite.
func TestComposableCompleteReadOnly(t *testing.T, ctx types.TestContext) {
	checkCaExists(t, ctx)
}

func checkCaExists(t *testing.T, ctx types.TestContext) {
	acmpcaClient := acmpca.NewFromConfig(GetAWSConfig(t))
	pcaArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "private_ca_arn")
	pcaType := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "private_ca_type")
	pcaUsageMode := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "private_ca_usage_mode")
	pcaKeyAlgorithm := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "private_ca_key_algorithm")
	pcaSigningAlgorithm := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "private_ca_signing_algorithm")

	t.Run("TestDoesCaExist", func(t *testing.T) {
		output, err := acmpcaClient.DescribeCertificateAuthority(context.TODO(), &acmpca.DescribeCertificateAuthorityInput{CertificateAuthorityArn: &pcaArn})
		if err != nil {
			t.Errorf("Error getting CA description: %v", err)
		}

		require.Equal(t, pcaArn, *output.CertificateAuthority.Arn, "Expected CA ARN to match")
		require.Equal(t, pcaType, string(output.CertificateAuthority.Type), "Expected CA type to match")
		require.Equal(t, pcaUsageMode, string(output.CertificateAuthority.UsageMode), "Expected CA usage mode to match")
		require.Equal(t, pcaKeyAlgorithm, string(output.CertificateAuthority.CertificateAuthorityConfiguration.KeyAlgorithm), "Expected key algorithm to match")
		require.Equal(t, pcaSigningAlgorithm, string(output.CertificateAuthority.CertificateAuthorityConfiguration.SigningAlgorithm), "Expected signing algorithm to match")
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
