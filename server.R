server <- function(session, input, output) 
{
  Data_ <- reactive(
    {
      if (input$region == "All")
      {
        Data
      }
      else
      {
        Data %>%
          filter(Region %in% input$region) 
      }
    }
  )
  
  output$plot1 <- renderPlot(
    {
      Data_() %>%
        group_by(Region, Country_Name) %>%
        summarise(Reports = n()) %>%
        ggplot(., aes(x = Country_Name, y = Reports, fill = Region)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "bottom") +
        # coord_flip() +
        labs(title = "Reports by Country and Region",
             subtitle = "Using eOddsMaker API",
             x = "Country / Region",
             y = "Reports",
             caption = "") +
        scale_fill_brewer(palette = "Spectral", name = "")
      # theme_bw()
    }
  )
  
  output$countries <- DT::renderDataTable(
    Data_(),
    options = list(pageLength = 8, scrollX = TRUE, scrollY = "480px", columnDefs = list(list(className = 'dt-center', targets = "_all"))), rownames = FALSE)
  
  observe(
    {
      updateSelectInput(session = session, inputId = "pais", choices = c("All", unique(Data_()[["Country_Name"]])), selected = "All")
    }
  )
}