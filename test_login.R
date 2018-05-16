library(shiny)
library(shinydashboard)

my_username <- "test"
my_password <- "abc"

###########################/ui.R/##################################

header <- dashboardHeader(title = "my heading")
sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
body <- dashboardBody(uiOutput("body") )

ui <- dashboardPage(header, sidebar, body)

###########################/server.R/##################################

server <- function(input, output, session) {
  Logged <- FALSE
  
  USER <<- reactiveValues(Logged = Logged)
  
  observe({ 
    if (USER$Logged == FALSE) {
      if (!is.null(input$Login)) {
        if (input$Login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          Id.username <- which(my_username == Username)
          Id.password <- which(my_password == Password)
          if (length(Id.username) > 0 & length(Id.password) > 0) {
            if (Id.username == Id.password) {
              USER$Logged <<- TRUE
            } 
          }
        } 
      }
    }    
  })
  
  output$sidebarpanel <- renderUI({
    if (USER$Logged == TRUE) { 
      dashboardSidebar(
        sidebarUserPanel("myuser",subtitle = a(icon("user"), "Logout", href="__logout__")),
        selectInput("in_var", "myvar", multiple = FALSE,
                    choices = c("option 1","option 2")),
        sidebarMenu(
          menuItem("Item 1", tabName = "t_item1", icon = icon("line-chart")),
          menuItem("Item 2", tabName = "t_item2", icon = icon("dollar")),
          menuItem("Item 3", tabName = "t_item3", icon = icon("credit-card")),
          menuItem("Item 4", tabName = "t_item4", icon = icon("share-alt"))
        ))}
  })
  
  output$body <- renderUI({
    if (USER$Logged == TRUE) {
      B <- c(2,3,4,3,7,5,4)
      
      box(
        title = p("Histogram", actionLink("Expand", "", icon = icon("expand"))), status = "primary", solidHeader = TRUE, width = 4,
        hist(B)
      )
    }
    if (USER$Logged == FALSE) {
      box(title = "Login",textInput("userName", "Username"),
          passwordInput("passwd", "Password"),
          br(),
          actionButton("Login", "Log in"))
    }
  })
}

shinyApp(ui, server)