---
title: Define and Publish WebAPI using Swagger
date: 2016-12-19 15:32:03
tags:
- WebAPI
- Swagger
---
Service registration/publish/documentation/discovery becomes a important step to support the MicroServices. One utility we can use is the Swagger which provides specification in defining the services in JSON, generate document/samples from it directly and make the API publishing and registration much earsier. 
<!-- more -->
Some sample.
```yaml
swagger: "2.0"
info:
  version: 1.0.0
  title: swagger-demo
  description: Description of the API in Markdown
host: petstore.swagger.io
tags:
  - greeting
basePath: /api
schemes: [http]
paths:
  /message/{name}:
    x-summary: Message operations
    x-description: Operation description in Markdown
    get:
      summary: Get a message of the day
      description: |
       Description of the operation in Markdown
      operationId: getMessage
      parameters:
        - name: name
          in: query
          description: name to include in the message
          type: string
          x-example: 'Hello, Adam!'
      responses:
        default:
          description: Bad request
        200:
          description: Successful response
          schema:
            $ref: '#/definitions/Message'
          examples:
            'application/json':
              message: 'Hello, Adam!'
definitions:
  Message:
    required:
      - message
    properties:
      message:
        type: string
        default: 'Hello, Adam!'
```
This defines an API like below
![image](/img/swagger.png)

See the sepecification at [Here](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md).
Try it out at [Here](http://editor.swagger.io/#/). Get the tutorial at [Here](https://help.apiary.io/api_101/swagger-tutorial/). 


