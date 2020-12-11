package services

import (
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/clients"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/logging"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/errorResponse"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/request"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/response"
	"fmt"
)

type {{.resourceName}}Service interface {
	Get{{.resourceName}}() (*response.{{.resourceName}}Response, *models.ErrorResponse)
}

type {{.resourceName}}ServiceImp struct {
	logger            logging.Logger
	{{.resourceFieldName}}ApiClient clients.{{.resourceName}}ApiClient
}

func New{{.resourceName}}Service(logger logging.Logger, {{.resourceFieldName}}ApiClient clients.{{.resourceName}}ApiClient) {{.resourceName}}Service {
	return &{{.resourceName}}ServiceImp{
		logger:            logger,
		{{.resourceFieldName}}ApiClient: {{.resourceFieldName}}ApiClient,
	}
}

func (service *{{.resourceName}}ServiceImp) Get{{.resourceName}}() (*response.{{.resourceName}}Response, *models.ErrorResponse) {
	resp, err := service.{{.resourceFieldName}}ApiClient.Get{{.resourceName}}()
	logFields := logging.NewLogFieldsBuilder().
		SetMethod("{{.resourceName}}Service.Get{{.resourceName}}").
		Build()
	if err != nil {
		errorMessage := fmt.Sprintf("{{.resourceName}}Service.Get{{.resourceName}} throws exception response: %v", resp)
		service.logger.Error(errorMessage, logFields)
		return nil, err
	}
	successMessage := fmt.Sprintf("{{.resourceName}}Service.Get{{.resourceName}} completed successfully, response: %v", resp)
	service.logger.Info(successMessage, logFields)
	return resp, nil
}