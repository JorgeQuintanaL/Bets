dashboardPage(
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
                  selectInput(inputId = "region", label = "Region", choices = c( "All", unique(Data["Region"])), selected = "All")
                )
              ),
              fluidRow(
                box(width = 6, height = 650,
                    title = "Ligas por pais",
                    solidHeader = TRUE, br(),
                    plotOutput("plot1", height = 550, width = 750),
                    collapsible = TRUE, status = "primary"
                )
              )
      ),
      tabItem(tabName = "resultados",
              h2("Widgets tab content")
      )
    )
  )
)
