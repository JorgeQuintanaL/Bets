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

Header <- dashboardHeader(title = "Bets App",
                          dropdownMenuOutput(outputId = "Messages"),
                          Notifications,
                          Task)
Sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Load Data",
             tabName = "load_data",
             icon = icon("cloud-download",
                         lib = "glyphicon"),
             selectInput(inputId = "sport",
                         label = "Sport",
                         choices = "Choose a Sport",
                         selected = "Football"),
             dateRangeInput(inputId = "daterange",
                            label = "Dates",
                            start = Sys.Date() - 7,
                            end = Sys.Date()),
             selectInput(inputId = "bookmarks",
                         label = "Bookmarks",
                         choices = "Choose a Bookmark"),
             actionButton(inputId = "load",
                          label = "Load")),
    menuItem(text = "Dashboard",
             tabName = "explore",
             icon = icon("dashboard"),
             menuSubItem(text = "By Region and Country",
                         tabName = "region_country",
                         icon = icon("globe",
                                     lib = "glyphicon")),
             menuSubItem(text = "By Country and League", 
                         tabName = "country_league",
                         icon = icon("globe", 
                                     lib = "glyphicon")),
             menuSubItem(text = "By League and Event"
                         , tabName = "league_event",
                         icon = icon("fire",
                                     lib = "glyphicon"))),
    menuItem("Results",
             tabName = "results",
             icon = icon("th"))
  )
)

Body <- dashboardBody(
  tabItems(
    tabItem(tabName = "region_country",
            fluidRow(
              infoBoxOutput(outputId = "progressBox"),
              infoBoxOutput(outputId = "valueBox"),
              infoBoxOutput(outputId = "approvalBox")
            ),
            fluidRow(
              # box(title = "Region",
              #     collapsible = TRUE,
              #     solidHeader = TRUE,
              #     status = "primary",
              #     selectInput(inputId = "region",
              #                 label = "Region",
              #                 choices = "Choose a Region")
              # ),
              # box(title = "Country",
              #     collapsible = TRUE,
              #     solidHeader = TRUE,
              #     status = "primary",
              #     selectInput(inputId = "country",
              #                 label = "Country",
              #                 choices = "Choose a Country")
              # )
            ),
            fluidRow(
              box(width = 6,
                  height = 600,
                  title = "Events by Region",
                  solidHeader = TRUE,
                  selectInput(inputId = "region",
                              label = "Region",
                              choices = "Choose a Region"),
                  br(),
                  plotOutput("plot1"),
                  collapsible = TRUE,
                  status = "primary"
              ),
              box(width = 6,
                  height = 600,
                  title = "Events by Country",
                  solidHeader = TRUE,
                  selectInput(inputId = "country",
                              label = "Country",
                              choices = "Choose a Country"),
                  br(),
                  plotOutput("plot2"),
                  collapsible = TRUE,
                  status = "primary"
              )
            )
    ),
    tabItem(tabName = "country_league",
            fluidRow(
              infoBoxOutput(outputId = "progressBox1"),
              infoBoxOutput(outputId = "valueBox1"),
              infoBoxOutput(outputId = "approvalBox1")
            ),
            fluidRow(
              box(width = 12,
                  height = 600,
                  title = "Map",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  plotlyOutput("map", height = 540))
            )
    ),
    tabItem(tabName = "league_event",
            fluidRow(
              infoBoxOutput(outputId = "progressBox2"),
              infoBoxOutput(outputId = "valueBox2"),
              infoBoxOutput(outputId = "approvalBox2")
            ),
            fluidRow(
              box(width = 12,
                  height = 600,
                  DTOutput(outputId = "countries"),
                  title = "Events Details",
                  collapsible = TRUE,
                  status = "primary",
                  solidHeader = TRUE)
            )
    )
  )
)

dashboardPage(Header, Sidebar, Body)
