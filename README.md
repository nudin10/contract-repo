# Contract Driven Development Kit
References:
- [What is contract driven development?](https://docs.specmatic.io/contract_driven_development.html)
- [What is OpenAPI?](https://www.openapis.org/what-is-openapi)
- [OpenAPI specifications](https://spec.openapis.org/oas/latest.html#openapi-specification)

## Overview
This repository contains API contracts for collaboration purposes based on the contract driven development practice.

It can be used for the following purposes:
- Maintain API contracts.
- Run mock servers based on API contracts.
- Run Swagger UI to display API documentations.

Pre-requisites:
- [Docker](https://docs.docker.com/desktop/) or [Podman](https://podman.io/docs/installation)

## How to use this repository
This repository uses `makefile` to run its shortcuts. All commands should be done from the root directory.

### Onboarding a new service
```bash
make new-service SERVICE={{service_name}}
```
Variables:
- [Mandatory] `{{service_name}}` : new service name. This will create the boilerplate directory structure that you can use.

### Adding a new API
`NOTE: Make sure that the service you are adding the API to already exist.`
```bash
make new-api SERVICE={{service_name}} API_NAME={{api_name}}
```
Variables:
- [Mandatory] `{{service_name}}` : service name.
- [Mandatory] `{{api_name}}` : new API name, for e.g, `order-summary`. This will create a boilerplate API file in the `/paths` subdirectory of the provided service.

### Mock a service
```bash
make start-mock SERVICE={{service_name}} RUNTIME={{container_runtime}} PRISM_IMAGE={{prism_image}} PORT={{port}}
```
Variables:
- [Mandatory] `{{service_name}}` : service name.
- [Optional] `{{container_runtime}}` : should be either `docker` or `podman`. Defaults to `docker`.
- [Optional] `{{prism_image}}` : should be a valid pullable [Prism](https://stoplight.io/open-source/prism) image. Defaults to `stoplight/prism:5`.
- [Optional] `{{port}}` : the port exposed for the mocked service.

### Stop a mock service
```bash
make stop-mock SERVICE={{service_name}} RUNTIME={{container_runtime}}
```
- [Mandatory] `{{service_name}}` : service name.
- [Optional] `{{container_runtime}}` : should be either `docker` or `podman`. Defaults to `docker`.

### Run Swagger UI
```bash
make start-swagger SERVICE={{service_name}} RUNTIME={{container_runtime}} SWAGGER_IMAGE={{swagger_image}}
```
- [Mandatory] `{{service_name}}` : service name.
- [Optional] `{{container_runtime}}` : should be either `docker` or `podman`. Defaults to `docker`.
- [Optional] `{{swagger_image}}` : should be a valid pullable [Swagger](https://swagger.io/docs/) image. Defaults to `swaggerapi/swagger-ui:v5.29.4`.
