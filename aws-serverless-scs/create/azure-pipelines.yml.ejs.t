---
to: azure-pipelines.yml
---
# https://github.com/denseidel/saas-platform-template/blob/master/devops/frontend-preview/azure-pipelines.yaml
# Add steps that analyze code, save build artifacts, deploy, and more:
# https://docs.microsoft.com/azure/devops/pipelines/languages/javascript

pr:
  branches:
    include:
    - master
  paths:
    include:
    - /
    exclude:
    - README.md
    - /adr/*
    - .adr-dir

pool:
  vmImage: 'Ubuntu-16.04'

steps:
- task: NodeTool@0
  inputs:
    versionSpec: '8.x'
  displayName: 'Install Node.js'

- script: |
    echo "setup credentials & dependencies"
  displayName: 'setup credentials & dependencies'

- script: |
    cd terraform
  env:
      PULUMI_ACCESS_TOKEN: $(pulumi.access.token)
      AWS_ACCESS_KEY_ID: $(aws.master.accesskey)
      AWS_SECRET_ACCESS_KEY: $(aws.master.accesssecret)
  displayName: 'build'

- script: |
    cd frontend
    npm run e2e
  displayName: 'run test'

- script: |
    # setup preview environment & artifact bucket & upload to artifiact bucket
    export PATH=$PATH:$HOME/.pulumi/bin
    cd devops/frontend-preview
    #npm install
    pulumi stack select denseidel/saas-template-frontend/dev
    pulumi up -y
  env:
      PULUMI_ACCESS_TOKEN: $(pulumi.access.token)
      AWS_ACCESS_KEY_ID: $(aws.master.accesskey)
      AWS_SECRET_ACCESS_KEY: $(aws.master.accesssecret)
  displayName: 'Setup Infrastucture & Deploy to preview environment'