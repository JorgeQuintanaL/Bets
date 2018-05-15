ui <- dashboardPage(
  dashboardHeader(title = "Testing Data Extraction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Estadisticas", tabName = "estadisticas", icon = icon("dashboard")),
      menuItem("Resultados", tabName = "resultados", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "estadisticas",
              fluidRow(
                box(
                  selectInput(inputId = "region", label = "Region", choices = c("All", unique(Data["Region"])), selected = "All")
                ),
                box(
                  selectInput(inputId = "pais", label = "Pais", choices = c("All", "A"), selected = "All")
                )
              ),
              fluidRow(
                box(width = 6,
                    height = 650,
                    title = "Eventos por Region",
                    solidHeader = TRUE, br(),
                    plotOutput("plot1", height = 550, width = 650),
                    collapsible = TRUE,
                    status = "primary"
                ),
                box(width = 6,
                    height = 650,
                    title = "Eventos por Pais",
                    solidHeader = TRUE, br(),
                    plotOutput("plot2", height = 550, width = 650),
                    collapsible = TRUE,
                    status = "primary"
                )
              ),
              fluidRow(
                box(width = 12,
                    height = 650,
                    DTOutput(outputId = "countries"),
                    title = "Descripcion de Eventos",
                    collapsible = TRUE,
                    status = "primary",
                    solidHeader = TRUE)
              ),
              fluidRow(
                box(width = 6,
                    height = 650,
                    title = "Mapa",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    status = "primary",
                    plotlyOutput("map", width = 650, height = 520)),
                box(width = 6,
                    height = 650,
                    title = "Mapa 2",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    status = "primary",
                    plotOutput("map2", width = 650, height = 520))
              )
      ),
      tabItem(tabName = "resultados",
              h2("Widgets tab content")
      )
    )
  )
)
