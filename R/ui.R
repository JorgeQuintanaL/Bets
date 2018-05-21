####################################################### MESSAGES, NOTIFICATIONS AND ALERTS ####################################################################
###############################################################################################################################################################
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

################################################################## HEADER #####################################################################################
###############################################################################################################################################################

Header <- dashboardHeader(title = "Bets App",
                          dropdownMenuOutput(outputId = "Messages"),
                          Notifications,
                          Task)

################################################################## SIDEBAR ####################################################################################
###############################################################################################################################################################
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
                                     lib = "glyphicon"))),
    menuItem("Results",
             tabName = "results",
             icon = icon("th"))
  )
)

####################################################################### BODY ##################################################################################
###############################################################################################################################################################
Body <- dashboardBody(
  tabItems(
    tabItem(tabName = "region_country",
            fluidRow(
              infoBoxOutput(outputId = "progressBox"),
              infoBoxOutput(outputId = "valueBox"),
              infoBoxOutput(outputId = "approvalBox")
            ),
            fluidRow(
              box(width = 6,
                  height = 650,
                  title = "Events by Region",
                  solidHeader = TRUE,
                  selectInput(inputId = "region",
                              label = "Region",
                              choices = "Choose a Region"),
                  plotlyOutput("plot1", height = 500),
                  collapsible = TRUE,
                  status = "primary"
              ),
              box(width = 6,
                  height = 650,
                  title = "Events by Country",
                  solidHeader = TRUE,
                  plotlyOutput("plot2", height = 590),
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
              box(width = 5,
                  height = 600,
                  title = "Map",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  plotlyOutput("map", height = 540)),
              box(width = 7,
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

############################################################## DASHBOARD PAGE #################################################################################
###############################################################################################################################################################
dashboardPage(Header, Sidebar, Body)
