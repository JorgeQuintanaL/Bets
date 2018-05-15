ui <- dashboardPage(
  dashboardHeader(title = "Testing Data"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Estadísticas", tabName = "estadisticas", icon = icon("dashboard")),
      menuItem("Resultados", tabName = "resultados", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "estadisticas",
              fluidRow(
                box(title = "Región",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    status = "primary",
                  selectInput(inputId = "region", label = "Región", choices = c("All", unique(Data["Region"])), selected = "All")
                ),
                box(title = "País",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    status = "primary",
                  selectInput(inputId = "pais", label = "País", choices = c("All", "A"), selected = "All")
                )
              ),
              fluidRow(
                box(width = 6,
                    height = 650,
                    title = "Eventos por Región",
                    solidHeader = TRUE, br(),
                    plotOutput("plot1", height = 550),
                    collapsible = TRUE,
                    status = "primary"
                ),
                box(width = 6,
                    height = 650,
                    title = "Eventos por País",
                    solidHeader = TRUE, br(),
                    plotOutput("plot2", height = 550),
                    collapsible = TRUE,
                    status = "primary"
                )
              ),
              fluidRow(
                box(width = 12,
                    height = 650,
                    DTOutput(outputId = "countries"),
                    title = "Descripción de Eventos",
                    collapsible = TRUE,
                    status = "primary",
                    solidHeader = TRUE)
              ),
              fluidRow(
                box(width = 12,
                    height = 650,
                    title = "Mapa",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    status = "primary",
                    plotlyOutput("map", height = 590))
              )
      ),
      tabItem(tabName = "resultados",
              h2("Widgets tab content")
      )
    )
  )
)
