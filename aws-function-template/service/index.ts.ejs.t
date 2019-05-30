---
to: <%= servicename %>/index.ts
---
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as fs from 'fs';

import { packageLambda } from "./lib";

// https://pulumi.io/aws/dynamodb.html
/* Create a mapping from 'route' to a count */
const tenantDb = new aws
  .dynamodb
  .Table("tenants", {
    attributes: [
      {
        name: "id",
        type: "S"
      }
    ],
    billingMode: "PAY_PER_REQUEST",
    hashKey: "id"
  });

packageLambda(`${__dirname}/create-tenant`, 'package.json');

const roleOfcreateTenantFunction = new aws
  .iam
  .Role("create_tenant", {
    assumeRolePolicy: `{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": [ "sts:AssumeRole" ],
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
]
}
`});

const policyAttachedToRoleOfcreateTenantFunction = new aws
  .iam
  .RolePolicy("create_tenant", {
    policy: `{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": [
      "dynamodb:PutItem"
    ],
    "Effect": "Allow",
    "Resource": "*"
  }
]
}
`,
    role: roleOfcreateTenantFunction.id
  });

const createTenantFunction = new aws
  .lambda
  .Function("create_tenant", {
    code: new pulumi
      .asset
      .FileArchive("./create-tenant/create-tenant.zip"),
    name: "create_tenant",
    handler: "app.lambdaHandler",
    role: roleOfcreateTenantFunction.arn,
    runtime: "nodejs8.10"
  });

const tenantManagementApiSpec = fs.readFileSync(`${__dirname}/openapi.yaml`, 'utf8');

const tenantMangementApiEndpoint = new aws
  .apigateway
  .RestApi("tenant-management", {
    description: "This api manages tenants",
    body: tenantManagementApiSpec
  });

const permitTenantMangementApiEndpointCallCreateTenantFunction = new aws
  .lambda
  .Permission("tenant_management", {
    action: "lambda:InvokeFunction",
    function: createTenantFunction.name,
    principal: "apigateway.amazonaws.com",
    sourceArn: tenantMangementApiEndpoint
      .executionArn
      .apply((executionArn: string) => {
        return `${executionArn}/*/*`;
      })
  });

const tenantMangementApiDeployment = new aws
  .apigateway
  .Deployment("tenant_management", {
    // @ts-ignore
    restApi: tenantMangementApiEndpoint.id,
    stageName: "dev"
  }, { dependsOn: [tenantMangementApiEndpoint] });

// Export the public URL for the HTTP service
export const id = createTenantFunction.invokeArn;
export const url = tenantMangementApiDeployment.invokeUrl;