server <- function(session, input, output) 
{
  
  Data_ <- eventReactive(input$load,
    {
      user <- "jorge.quintana.l"
      pssw <- "jorge.quintana.l"
      # JSON_stream <- stream_in(
      #   gzcon(
      #     url(
      #       paste0("http://services.eoddsmaker.net/demo/feeds/V2.0/markets.ashx?l=1&u=", user,
      #              "&p=", pssw,
      #              "&bid=", c(1,2,14,22,47,65,83,91,93,95,96,97,98,100,103,105,106,107,108,109,110,111,112,113,114,117,118,119,120,121,122,123,124,125,126,127,128,129,130),
      #              "&sid=", 50, "&tsmp=", 2018-04-23, "T", 18:00:00, "&frm=json")
      #     )
      #   )
      # )
      load("JSON_stream.rda")
      Regions <- read.delim(file = "Regions.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
      # register_google(key = "AIzaSyAwoxxqyumTJSm1ksS29h4sbv3eoZO7YeA")
      
      JSON_stream$S[[1]] %>%
        unnest() %>%
        group_by(N1) %>%
        unnest(L) %>%
        group_by(N2) %>%
        unnest(E) %>%
        group_by(I3) %>%
        do(., .[which(as.logical(length(unlist(.$M) != 0))), ]) %>%
        unnest(M) %>%
        unnest(B) %>%
        unnest(O) %>%
        select(I, N, I1, N1, I2, N2, I3, DT, RND, BKS, T1, T2, T1I, T2I, SC, K, I4, H, I5, BTDT, N3, V) %>%
        setNames(c("Sport_ID", "Sport_Name", "Country_ID", "Country_Name", "League_ID", "League_Name", "Event_ID", "Event_Datetime", "Round",
                   "Bookies", "Team1", "Team2", "Team1_ID", "Team2_ID", "Score", "Market_Code", "I4", "Market_Arg", "BookMark_ID",
                   "BOT_Date", "Odd_Name", "Odd_Value")) %>%
        mutate(Event_Datetime = anytime(Event_Datetime)) %>%
        ungroup() %>%
        left_join(x = .,
                  y = Regions,
                  by = "Country_Name")
    }
  )
  
  df2 <- reactive(
    {
      df2 <- read.delim(file = "world_codes.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
      WorldData <- map_data("world")
      WorldData %>% 
        filter(region != "Antarctica") -> WorldData
      
      Data_() %>%
        group_by(Country_Name) %>%
        summarise(Reports = n()) %>%
        left_join(x = .,
                  y = df2,
                  by = "Country_Name") -> df2  
    }
  )
  
  output$plot1 <- renderPlot(
    {
      Data_() %>%
        filter(Region %in% input$region) %>%
        group_by(Region, Country_Name) %>%
        summarise(Reports = n()) %>%
        ggplot(., aes(x = Country_Name, y = Reports, fill = Region)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "bottom") +
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
        filter(Region %in% input$region, Country_Name %in% input$pais) %>%
        group_by(League_Name) %>%
        summarise(Reports = n()) %>%
        top_n(10) %>%
        ggplot(., aes(x = League_Name, y = Reports, fill = League_Name)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "bottom") +
        labs(title = "Reports by Country and League",
             subtitle = "Using eOddsMaker API",
             x = "League",
             y = "Reports",
             caption = "") +
        scale_colour_hue()
    }
  )
  
  output$valueBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Participacion",
              icon = icon("stats", lib = "glyphicon"),
              color = "green",
              fill = TRUE)
    }
  )
  
  output$progressBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Valor Invertido",
              icon = icon("ok-circle", lib = "glyphicon"),
              color = "red",
              fill = TRUE)
    }
  )
  
  output$approvalBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", paste0(0, "%")),
              title = "Ganancia",
              icon = icon("thumbs-up", lib = "glyphicon"),
              color = "yellow",
              fill = TRUE)
    }
  )
  
  output$map <- renderPlotly(
    {
      plot_geo(df2()) %>%
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
          select(Sport_Name, Country_Name, League_Name, Event_Datetime, Round, Bookies, Team1, Team2, BookMark_ID, Odd_Name, Odd_Value)
      }
      else
      {
        Data_() %>%
          select(Sport_Name, Country_Name, League_Name, Event_Datetime, Round, Bookies, Team1, Team2, BookMark_ID, Odd_Name, Odd_Value) %>%
          filter(Country_Name %in% selected_country())
      }
    },
    options = list(pageLength = 13, scrollX = TRUE, scrollY = "480px", columnDefs = list(list(className = 'dt-center', targets = "_all"))), rownames = FALSE)
  
  observe(
    {
      updateSelectInput(session = session, inputId = "pais", choices = unique(Data_()[Data_()$Region %in% input$region, "Country_Name"]))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "region", choices = unique(Data_()[, "Region"]))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "casas", choices = Consulta(Query = "SELECT nombre_casa FROM casas WHERE incluir = 'si'", Table = "casas"))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "sport", choices = Consulta(Query = "SELECT nombre_deporte FROM deportes", Table = "deportes"))
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
  
  output$menu <- renderMenu(
    {
      sidebarMenu(menuItem("Menu item", icon = icon("calendar")))
    }
  )
}