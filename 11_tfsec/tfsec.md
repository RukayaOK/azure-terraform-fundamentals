
brew install tfsec


run 
tfsec 

or

tfsec --config-file tfsec.yml

all rules
https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/

pipeline
https://jakewalsh.co.uk/securing-your-deployment-with-scanning-using-github-actions/

definitions:
  caches:
    tflint: ~/.tflint.d/plugins


  https://jainsaket-1994.medium.com/how-to-use-tfsec-in-the-pipeline-7d2c211f4feb