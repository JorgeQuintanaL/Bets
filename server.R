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
        labs(title = "Reports by Region and Country",
             subtitle = "Using eOddsMaker API",
             x = "Country / Region",
             y = "Reports",
             caption = "") +
        scale_colour_hue()
      # theme_bw()
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
        # coord_flip() +
        labs(title = "Reports by Country and League",
             subtitle = "Using eOddsMaker API",
             x = "League",
             y = "Reports",
             caption = "") +
        scale_colour_hue()
      # theme_bw()
    }
  )
  
  output$map <- renderPlotly(
    {
      plot_geo(df2) %>%
        add_trace(z = ~Reports,
                  color = ~Reports,
                  colors = "Blues",
                  text = ~Country_Name,
                  locations = ~Code,
                  marker = list(line = list(color = toRGB("grey"), width = 0.5))) %>%
        colorbar(title = "Eventos") %>%
        layout(title = "Eventos por Pais",
               geo = list(showframe = FALSE,
                          showcoastlines = TRUE,
                          projection = list(type = "Mercator"),
                          lakecolor = toRGB("white")),
               legend = list(orientation = "h"))
    }
  )
  
  # output$map2 <- renderPlot(
  #   {
  #     ggplot() +
  #       geom_map(data = WorldData,
  #                map = WorldData,
  #                aes(x = long, y = lat, group = group, map_id = region),
  #                fill = "white",
  #                colour = "black",
  #                size = 0.3) +
  #       geom_map(data = df2,
  #                map = WorldData,
  #                aes(fill = Reports, map_id = Country_Name),
  #                colour = "black",
  #                size = 0.5) +
  #       coord_map("rectangular",
  #                 lat0 = 0,
  #                 xlim = c(-180,180),
  #                 ylim = c(-60, 90)) +
  #       labs(fill = "Eventos", 
  #            title = "Numero de Eventos por Pais",
  #            x = "",
  #            y="",
  #            subtitle = "Actividad basada en Bookies",
  #            caption = "Prueba") +
  #       theme(legend.position = "right")
  #   }
  # )
  
  output$countries <- DT::renderDataTable(
    Data_() %>%
      select(Sport_Name, Country_Name, League_Name, Event_Datetime, Round, Number_Bookies, Team1, Team2, BookMark_ID, Odd_Name, Odd_Value),
    options = list(pageLength = 13, scrollX = TRUE, scrollY = "480px", columnDefs = list(list(className = 'dt-center', targets = "_all"))), rownames = FALSE)
  
  observe(
    {
      updateSelectInput(session = session, inputId = "pais", choices = c("All", unique(Data_()[["Country_Name"]])), selected = input$pais)
    }
  )
}