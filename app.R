library(shiny)
library(ggplot2)
library(dplyr)
library(readxl)

# Lê o arquivo xlsx com os dados
dados <- read_excel("income_democracy.xlsx")
dados[is.na(dados)] <- 0

# Define a interface da aplicação
ui <- fluidPage(

    # Define o título da aplicação
    titlePanel("Análise de dados"),

    # Define a barra lateral com as opções de input
    sidebarLayout(
        sidebarPanel(

            # Define o seletor de cor para o gráfico
            pickerInput(
                inputId = "color_sel",
                label = "Selecione a cor da linha:",
                choices = c("blue", "red", "green"),
                multiple = FALSE
            ),

            # Define os sliders para o eixo x
            sliderInput("x_min", "Eixo X mínimo:",
                min = min(dados$year), max = max(dados$year),
                value = min(dados$year)
            ),
            sliderInput("x_max", "Eixo X máximo:",
                min = min(dados$year), max = max(dados$year),
                value = max(dados$year)
            ),

            # Define os sliders para o eixo y
            sliderInput("y_min", "Eixo Y mínimo:",
                min = min(dados$log_gdppc), max = max(dados$log_gdppc),
                value = min(dados$log_gdppc)
            ),
            sliderInput("y_max", "Eixo Y máximo:",
                min = min(dados$log_gdppc), max = max(dados$log_gdppc),
                value = max(dados$log_gdppc)
            )
        ),

        # Define o painel principal com o gráfico
        mainPanel(
            plotOutput("grafico")
        )
    )
)

# Define o servidor da aplicação
server <- function(input, output) {
    # Cria o gráfico
    output$grafico <- renderPlot({
        ggplot(data = dados, aes(x = year, y = log_gdppc)) +
            geom_line(color = input$color_sel) +
            scale_x_continuous(limits = c(input$x_min, input$x_max)) +
            scale_y_continuous(limits = c(input$y_min, input$y_max))
    })
}

# Roda a aplicação
shinyApp(ui, server)
