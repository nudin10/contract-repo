.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo ""
	@echo "More info in README.md"
	@echo ""
	@echo "Available targets: "
	@echo "----------------------------------------------------"
	@echo " make new-service SERVICE=service_name"
	@echo " make new-api API_NAME=api_name SERVICE=service_name"
	@echo " make start-mock SERVICE=service_name RUNTIME=podman"
	@echo " make stop-mock SERVICE=service_name RUNTIME=podman"
	@echo " make start-swagger SERVICE=service_name"
	@echo " make stop-swagger SERVICE=service_name"
	@echo "----------------------------------------------------"
	@echo ""

TEMPLATE_PATH := templates
SERVICE ?= new-service
SERVICE_PATH := services/$(SERVICE)

.PHONY: new-service
new-service:
	@mkdir -p $(SERVICE_PATH)/paths $(SERVICE_PATH)/components
	@mkdir -p $(SERVICE_PATH)/components/schemas
	@mkdir -p $(SERVICE_PATH)/components/parameters
	@mkdir -p $(SERVICE_PATH)/components/responses
	@mkdir -p $(SERVICE_PATH)/components/request_bodies
	@mkdir -p $(SERVICE_PATH)/components/headers
	@sed -e "s|((service-name))|$(SERVICE)|g" $(TEMPLATE_PATH)/service.template.yaml >  $(SERVICE_PATH)/$(SERVICE).yaml
	@touch $(SERVICE_PATH)/components/components.yaml
	@echo "Initialized service directory structure for '$(SERVICE)'"

API_NAME ?= new-api

.PHONY: new-api
new-api:
	@touch $(SERVICE_PATH)/paths/$(API_NAME).yaml
	@cp $(TEMPLATE_PATH)/api.template.yaml $(SERVICE_PATH)/paths/$(API_NAME).yaml
	@echo "Added new API '$(API_NAME)' for '$(SERVICE)'"

RUNTIME ?= docker
PORT ?= 4010
SPEC_DIR ?= $(SERVICE_PATH)
PRISM_IMAGE?= stoplight/prism:5

.PHONY: start-mock
start-mock:
	@$(RUNTIME) run -d \
	-p 127.0.0.1:$(PORT):4010 \
	-v $(CURDIR)/$(SPEC_DIR):/spec \
	--name mock-$(SERVICE) \
	$(PRISM_IMAGE) mock -h 0.0.0.0 /spec/$(SERVICE).yaml

.PHONY: stop-mock
stop-mock:
	@$(RUNTIME) rm -f mock-$(SERVICE)

UI_PORT ?= 8080
SWAGGER_IMAGE?= swaggerapi/swagger-ui:v5.29.4
.PHONY: start-swagger
start-swagger:
	@$(RUNTIME) run -d \
	-p 127.0.0.1:$(UI_PORT):8080 \
	-v $(CURDIR)/$(SPEC_DIR):/oas \
	-e SWAGGER_JSON=/oas/$(SERVICE).yaml \
	--name swagger-ui \
	$(SWAGGER_IMAGE) 

.PHONY: stop-swagger
stop-swagger:
	@$(RUNTIME) rm -f swagger-ui
