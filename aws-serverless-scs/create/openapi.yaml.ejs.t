---
to: openapi.yaml
---
openapi: 3.0.2
info:
  title: "Tenant Mangement API"
  description: "Add a user to a tenant and add his tenantId in his identity profile, remove a user from a tenant. To access the API register with the [developer portal](test#) for production you need to call the api with the _access_token_ of your user, the api checks if the user is allowed to change the tenent status(is admin of the tenant he want to modify)."
  version: "1.0.0"
  termsOfService: "https://developers.google.com/terms/"
  contact:
    name: Dennis Seidel
    email: den.seidel@gmail.com
    url: https://github.com/denseidel/saas-platform-template/tree/master/services/tenent-management
servers: 
  - url: "/"
x-amazon-apigateway-request-validators:
  all:
    validateRequestBody: true
    validateRequestParameters: true
  params-only:
    validateRequestBody: false
    validateRequestParameters: true
x-amazon-apigateway-request-validator: "all"
paths:
  /tenants:
    post:
      operationId: createTenent
      summary: Create a tenant.
      description: "This takes the name, role, product group, (optional) tenantId of a person and updates this given the caller identified by the _access_token_ has the rights to either register this for himself or is admin of the tenantId provided."
      requestBody:
        description: "Description of a tenant entry"
        content:
          application/json:
            schema:
              type: object
              properties:
                tenantName:
                  type: string
                plan:
                  type: string
                name:
                  type: string
                role:
                  type: string
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Tenant'
      x-amazon-apigateway-integration:
        type: aws_proxy
        httpMethod: POST
        uri: 'arn:aws:apigateway:eu-central-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-central-1:825465353745:function:create_tenant/invocations'
  /tenants/{id}:
    get:
      operationId: getTenent
      summary: Get the tenant data for a tenentId
      parameters: 
        - in: path
          name: id
          schema:
            type: integer
          required: true
          description: numeric id of the tenant
      responses:
        '200':
          description: OK
      x-amazon-apigateway-integration:
        type: mock
          
components:
  schemas:
    Tenant:
      type: object
      properties:
        tenantId:
          type: string
        tenantName:
          type: string
        plan:
          type: string
        users:
          type: array
          items:
            type: object
            properties:
              name:
                type: string
              role:
                type: string
      required: 
        - users
        - plan
        - tenentId
        - tenantName