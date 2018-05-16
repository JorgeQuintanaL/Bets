Messages <- dropdownMenu(type = "messages",
             messageItem(
               from = "",
               message = "Sales are steady this month."
             ),
             messageItem(
               from = "New User",
               message = "How do I register?",
               icon = icon("question"),
               time = "13:45"
             ),
             messageItem(
               from = "Support",
               message = "The new server is ready.",
               icon = icon("life-ring"),
               time = "2014-12-01"
             )
)

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

Header <- dashboardHeader(title = "Testing Data", dropdownMenuOutput("Messages"), Notifications, Task)
Sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Tablero de Control", tabName = "explorar", icon = icon("dashboard"),
             menuSubItem(text = "Filtrar los Datos", tabName = "generar_consulta", icon = icon("cloud")),
             menuSubItem(text = "Filtrar los Datos", tabName = "frecuencias", icon = icon("chart-pie"))),
    menuItem("Resultados", tabName = "resultados", icon = icon("th"))
  )
)

Body <- dashboardBody(
  tabItems(
    tabItem(tabName = "frecuencias",
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

dashboardPage(Header, Sidebar, Body)
