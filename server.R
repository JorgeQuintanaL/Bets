server <- function(session, input, output) 
{
  user <- reactive(
    {
      curUser <- session$user
      if (is.null(curUser))
      {
        print("User NULL")
      }
      
      userData <- as.data.frame(filter(passwordData, usuario==curUser))
      if (nrow(user) < 1)
      {
        print("No se encontraron registros para este usuario")
      }
      user[1,]
    }
  )
  
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
        labs(title = "Reports by Region and Country",
             subtitle = "Using eOddsMaker API",
             x = "Country / Region",
             y = "Reports",
             caption = "") +
        scale_colour_hue()
    }
  )
  
  output$plot2 <- renderPlot(
    {
      Data_() %>%
        group_by(Country_Name, League_Name) %>%
        summarise(Reports = n()) %>%
        top_n(10) %>%
        filter(Country_Name %in% input$pais) %>%
        ggplot(., aes(x = League_Name, y = Reports, fill = League_Name)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "bottom") +
        labs(title = "Reports by Country and League",
             subtitle = "Using eOddsMaker API",
             x = "League",
             y = "Reports",
             caption = "") +
        scale_colour_hue()
    }
  )
  
  output$map <- renderPlotly(
    {
      plot_geo(df2) %>%
        add_trace(z = ~Reports,
                  color = ~Reports,
                  colors = "Reds",
                  text = ~Country_Name,
                  locations = ~Code,
                  marker = list(line = list(color = toRGB("grey"), width = 0.5))) %>%
        colorbar(title = "Eventos") %>%
        layout(title = "Eventos por Pais",
               geo = list(showframe = FALSE,
                          showcoastlines = TRUE,
                          showland = TRUE,
                          landcolor = toRGB("gray85"),
                          projection = list(type = "Mercator"),
                          lakecolor = toRGB("white")),
               legend = list(orientation = "h"),
               dragmode = "select")
    }
  )
  
  selected_country <- reactive(
    {
      d <- event_data("plotly_click")
      if (is.null(d))
      {
        return(NULL)
      }
      else
      {
        index <- as.numeric(d[2]$pointNumber) + 1
        df2[row.names(df2) == index, "Country_Name"]
      }
    }
  )
  
  output$countries <- DT::renderDataTable(
    {
      if (is.null(selected_country()))
      {
        Data_() %>%
          select(Sport_Name, Country_Name, League_Name, Event_Datetime, Round, Number_Bookies, Team1, Team2, BookMark_ID, Odd_Name, Odd_Value)
      }
      else
      {
        Data_() %>%
          select(Sport_Name, Country_Name, League_Name, Event_Datetime, Round, Number_Bookies, Team1, Team2, BookMark_ID, Odd_Name, Odd_Value) %>%
          filter(Country_Name %in% selected_country())
      }
    },
    options = list(pageLength = 13, scrollX = TRUE, scrollY = "480px", columnDefs = list(list(className = 'dt-center', targets = "_all"))), rownames = FALSE)
  
  observe(
    {
      updateSelectInput(session = session, inputId = "pais", choices = c("All", unique(Data_()[["Country_Name"]])), selected = input$pais)
    }
  )
  
  output$Messages <- renderMenu(
    {
      messageData <- Consulta(Query = "SELECT * FROM MENSAJES", Table = "mensajes")
      msgs <- apply(messageData, 1,
                    function(row) 
                    {
                      messageItem(from = row[["enviado"]], message = row[["mensaje"]])
                    }
      )
      dropdownMenu(type = "messages", .list = msgs)
    }
  )
}