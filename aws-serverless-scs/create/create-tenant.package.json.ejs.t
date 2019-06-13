---
to: <%= functionname %>/package.json
---
{
  "name": "<%= functionname %>",
  "version": "1.0.0",
  "description": "hello world sample for NodeJS",
  "main": "app.js",
  "repository": "https://github.com/awslabs/aws-sam-cli/tree/develop/samcli/local/init/templates/cookiecutter-aws-sam-hello-nodejs",
  "author": "SAM CLI",
  "license": "MIT",
  "ignoredFilesAtDeployment": [
    "**/*.zip",
    "tests/**",
    "node_modules/**"
  ],
  "dependencies": {
    "aws-sdk": "^2.441.0"
  },
  "scripts": {
    "test": "mocha tests/unit/"
  },
  "devDependencies": {
    "chai": "^4.1.2",
    "mocha": "^5.1.1"
  }
}
