import (
	"ecomcore-gitlab.trendyol.com/{{.projectName}}/src/services"
	"github.com/gin-gonic/gin"
	"net/http"
)


type {{.resourceName}}Controller struct {
	{{.resourceName}}Service services.{{.resourceName}}Service
}

func New{{.resourceName}}Controller({{.resourceName}}Service services.{{.resourceName}}Service) Controller {
	return &{{.resourceName}}Controller{
		{{.resourceName}}Service: contractService,
	}
}

// @Tags {{.resourceName}}Controller
// @Description Get {{.resourceName}}
// @Accept  json
// @Produce  html
// @Success 200 {object} response.{{.resourceName}}Response
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
// @Router /v1/contract [get]
func (controller *{{.resourceName}}Controller) Get{{.resourceName}}() func(context *gin.Context) {
	return func(context *gin.Context) {
		get{{.resourceName}}, err := controller.{{.resourceName}}Service.Get{{.resourceName}}()

		if err != nil {
			context.JSON(err.StatusCode, err)
			return
		}
		context.JSON(http.StatusOK, get{{.resourceName}})
	}
}

func (controller *{{.resourceName}}Controller) Register(engine *gin.Engine) {
	engine.GET("{{.resource}}", controller.Get{{.resourceName}}())
}
