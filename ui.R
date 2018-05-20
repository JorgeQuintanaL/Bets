Notifications <- dropdownMenu(type = "notifications",
                              notificationItem(
                                text = "5 new users today",
                                icon("users")
                              ),
                              notificationItem(
                                text = "12 items delivered",
                                icon("truck"),
                                status = "success"
                              ),
                              notificationItem(
                                text = "Server load at 86%",
                                icon = icon("exclamation-triangle"),
                                status = "warning"
                              )
)

Task <- dropdownMenu(type = "tasks", badgeStatus = "success",
                     taskItem(value = 90, color = "green",
                              "Documentation"
                     ),
                     taskItem(value = 17, color = "aqua",
                              "Project X"
                     ),
                     taskItem(value = 75, color = "yellow",
                              "Server deployment"
                     ),
                     taskItem(value = 80, color = "red",
                              "Overall project"
                     )
)

Header <- dashboardHeader(title = "Testing Data", dropdownMenuOutput(outputId = "Messages"), Notifications, Task)
Sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Carga de Datos", tabName = "carga", icon = icon("cloud", lib = "glyphicon"),
             selectInput(inputId = "sport",
                         label = "Deporte",
                         choices = "Seleccione un Deporte",
                         selected = "Futbol"),
             dateRangeInput(inputId = "daterange",
                            label = "Fechas",
                            start = Sys.Date() - 7,
                            end = Sys.Date()),
             selectInput(inputId = "casas",
                         label = "Casa de Apuestas",
                         choices = "Seleccione una Casa"),
             actionButton(inputId = "load",
                          label = "Cargar")),
    menuItem(text = "Tablero de Control",
             tabName = "explorar",
             icon = icon("dashboard")),
    menuItem("Resultados",
             tabName = "resultados",
             icon = icon("th"))
  )
)

Body <- dashboardBody(
  tabItems(
    tabItem(tabName = "explorar",
            fluidRow(
              infoBoxOutput("progressBox"),
              infoBoxOutput("valueBox"),
              infoBoxOutput("approvalBox")
            ),
            fluidRow(
              box(title = "Región",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  selectInput(inputId = "region", label = "Región", choices = "Seleccione una Region")
              ),
              box(title = "País",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  selectInput(inputId = "pais", label = "País", choices = "Seleccione un Pais")
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
            )
    ),
    tabItem(tabName = "resultados",
            fluidRow(
              box(width = 12,
                  height = 600,
                  title = "Mapa",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  plotlyOutput("map", height = 540))
            ),
            fluidRow(
              box(width = 12,
                  height = 650,
                  DTOutput(outputId = "countries"),
                  title = "Descripción de Eventos",
                  collapsible = TRUE,
                  status = "primary",
                  solidHeader = TRUE)
            )
    )
  )
)

dashboardPage(Header, Sidebar, Body)
