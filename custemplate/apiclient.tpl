package clients

import (
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/common/constants"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/logging"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models"
	error "ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/errorResponse"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/request"
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/models/response"
	"fmt"
	"gopkg.in/resty.v1"
	"net/http"
)

type {{.apiClient.name}}ApiClient interface {
	Get{{.apiClient.name}}() (*response.{{.apiClient.name}}Response, *error.ErrorResponse)
}

type {{.apiClient.name}}ClientImp struct {
	logger     logging.Logger
	httpClient *resty.Client
	apiConfig  models.ApiConfig
}

func New{{.apiClient.name}}ApiClient(logger logging.Logger, httpClient *resty.Client, config models.ApiConfig) {{.apiClient.name}}ApiClient {
	return &{{.apiClient.name}}ClientImp{
		logger:     logger,
		httpClient: httpClient,
		apiConfig:  config,
	}
}

func (client *{{.apiClient.name}}ClientImp) Get{{.apiClient.name}}() (*response.{{.apiClient.name}}Response, *error.ErrorResponse) {
	getContactUrl := fmt.Sprintf("%s{{.apiClient.url}}", client.apiConfig.{{.apiClient.name}}ApiUrl)
	resp, err := client.httpClient.R().
		Get(getContactUrl)

	logFields := logging.NewLogFieldsBuilder().
		SetMethod("{{.apiClient.name}}ApiClient.Get{{.apiClient.name}}").
		SetCustomField(constants.Url, getContactUrl).
		Build()

	if err != nil {
		errorMessage := constants.ApiReturnError
		logFields[constants.Error] = err.Error()
		logFields.SetIsFatal(true)
		logFields.SetIsAlertNeeded(true)
		client.logger.Error(errorMessage, logFields)
		parameters := error.ErrorParameters{Content: err}
		errorResponse := error.NewErrorBuilder().
			SetErrorWithParameter(http.StatusInternalServerError, constants.{{.apiClient.name}}ApiReturnedError, parameters).
			Build()
		return nil, &errorResponse
	}

	statusCode := resp.StatusCode()
	logFields[constants.StatusCode] = statusCode

	if statusCode != http.StatusOK {
		errorMessage := fmt.Sprintf(constants.ApiReturnedStatusCode, statusCode)
		client.logger.Error(errorMessage, logFields)
		parameters := error.ErrorParameters{Content: string(resp.Body())}
		errorResponse := error.NewErrorBuilder().
			SetErrorWithParameter(statusCode, constants.{{.apiClient.name}}ApiUnexpectedStatusCodeError, parameters).
			Build()
		return nil, &errorResponse
	}
	contractResp := response.{{.apiClient.name}}Response{}
	contractResp.Content = string(resp.Body())

	client.logger.Info(fmt.Sprintf("Get{{.apiClient.name}} completed successfully. Response: %v", contractResp), logFields)
	return &contractResp, nil
}
