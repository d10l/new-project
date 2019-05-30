---
to: <%= servicename %>/package.json
---
{
    "name": "aws-typescript",
    "devDependencies": {
        "@types/archiver": "^2.1.3",
        "@types/node": "latest"
    },
    "dependencies": {
        "@pulumi/aws": "latest",
        "@pulumi/awsx": "latest",
        "@pulumi/pulumi": "latest",
        "archiver": "^3.0.0"
    }
}
