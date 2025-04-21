package test_test

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/service/lambda"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/kr/pretty"
)

func TestDefaults(t *testing.T) {
	// Setup terratest
	rootFolder := "../"
	terraformFolderRelativeToRoot := "examples/simple"

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Upgrade:      true,
		NoColor:      os.Getenv("CI") == "true",
		Vars: map[string]interface{}{
			"namespace": strings.ToLower(random.UniqueId()),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Print out the Terraform Output values
	_, _ = pretty.Print(terraform.OutputAll(t, terraformOptions))

	// AWS Session
	sessionConfig, err := config.LoadDefaultConfig(
		context.Background(),
		config.WithRegion("us-east-1"),
	)

	if err != nil {
		t.Fatal(err)
	}

	lambdaClient := lambda.NewFromConfig(sessionConfig)

	// Fetch the Lambda function ARN from the Terraform output
	lambdaFunctionArn := terraform.Output(t, terraformOptions, "lambda_function_arn")

	// Invoke the Lambda function
	payload := []byte("{}") // empty object as event
	resp, err := lambdaClient.Invoke(context.TODO(), &lambda.InvokeInput{
		FunctionName: &lambdaFunctionArn,
		Payload:      payload,
	})
	if err != nil {
		t.Fatalf("Failed to invoke Lambda function: %v", err)
	}

	if resp.FunctionError != nil {
		t.Fatalf("Lambda function returned an error: %s", *resp.FunctionError)
	}

	// Verify the response
	expectedOutput := "{\"statusCode\":200,\"body\":\"{\\\"message\\\":\\\"Hello, World!\\\"}\"}"
	if string(resp.Payload) != expectedOutput {
		t.Fatalf("Lambda function output mismatch:\n%s", makediff(expectedOutput, string(resp.Payload)))
	}

	t.Log("Lambda function invoked successfully with the expected output")
}

func makediff(want interface{}, got interface{}) string {
	s := fmt.Sprintf("\nwant: %# v", pretty.Formatter(want))
	s = fmt.Sprintf("%s\ngot: %# v", s, pretty.Formatter(got))
	diffs := pretty.Diff(want, got)
	s += "\ndifferences: "
	for _, d := range diffs {
		s = fmt.Sprintf("%s\n  - %s", s, d)
	}
	return s
}
