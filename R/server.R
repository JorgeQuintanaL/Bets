server <- function(session, input, output) 
{
################################################################# DATA LOADING AND PROCESSING #################################################################
###############################################################################################################################################################
  Data_ <- eventReactive(input$load,
    {
      # user <- "jorge.quintana.l"
      # pssw <- "jorge.quintana.l"
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
      load("./data/JSON_stream.rda")
      Regions <- read.delim(file = "./data/Regions.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
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
      df2 <- read.delim(file = "./data/world_codes.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
      WorldData <- map_data("world")
      WorldData %>% 
        filter(region != "Antarctica") -> WorldData
      
      Data_() %>%
        group_by(Country_Name) %>%
        summarise(Reports = n()) %>%
        left_join(x = .,
                  y = df2,
                  by = "Country_Name")
    }
  )
  
########################################################################### PLOTS #############################################################################
###############################################################################################################################################################
  
  output$plot1 <- renderPlotly(
    {
      Data_() %>%
        filter(Region %in% input$region) %>%
        group_by(Region, Country_Name) %>%
        distinct(Event_ID) %>%
        summarise(Reports = n()) %>%
        plot_ly(source = "subset") %>%
        add_trace(x = ~Country_Name,
                  y = ~Reports,
                  type = "bar",
                  color = ~Region,
                  text = ~paste("Region: ", Region,
                                "<br>Country Name: ", Country_Name,
                                "<br>Reports: ", Reports),
                  hoverinfo = "text") %>%
        layout(title = "Reports by Region and Country",
               xaxis = list(title = ""),
               yaxis = list(title = "Reports"),
               legend = list(orientation = "h"),
               dragmode = "subset") 
    }
  )
  
  output$plot2 <- renderPlotly(
    {
      if (is.null(selected_country_bar()))
      {
        return(NULL)
      }
      else
      {
        Data_() %>%
          filter(Region %in% input$region, Country_Name %in% selected_country_bar()) %>%
          group_by(League_Name) %>%
          distinct(Event_ID, .keep_all = TRUE) %>%
          summarise(Reports = n()) %>%
          top_n(10) %>%
          plot_ly() %>%
          add_trace(x = ~League_Name,
                    y = ~Reports,
                    type = "bar",
                    color = ~League_Name,
                    text = ~paste("Region: ", input$region,
                                  "<br>Country Name: ", selected_country_bar(),
                                  "<br>League Name: ", League_Name,
                                  "<br>Reports: ", Reports),
                    hoverinfo = "text") %>%
          layout(title = "Reports by Country and League",
                 xaxis = list(title = ""),
                 yaxis = list(title = "Reports"),
                 legend = list(orientation = "h"))
      }
    }
  )
  
  output$map <- renderPlotly(
    {
      plot_geo(data = df2(), source = "select") %>%
        add_trace(z = ~Reports,
                  color = ~Reports,
                  colors = "Reds",
                  locations = ~Code,
                  text = ~paste("Region: ", input$region,
                                "<br>Country Name: ", Country_Name,
                                "<br>Reports: ", Reports),
                  marker = list(line = list(color = toRGB("#d1d1d1"), width = 0.5))) %>%
        colorbar(title = "Events") %>%
        layout(title = "Events by Country",
               geo = list(
                 showframe = FALSE,
                 showcoastlines = FALSE,
                 projection = list(type = "orthographic"),
                 resolution = "100",
                 showcountries = TRUE,
                 countrycolor = "#d1d1d1",
                 showocean = TRUE,
                 oceancolor = "#c9d2e0",
                 showlakes = TRUE,
                 lakecolor = "#99c0db",
                 showrivers = TRUE,
                 rivercolor = "#99c0db"),
               legend = list(orientation = "h"))
    }
  )
  
#################################################################### VALUE AND INFO BOXES #####################################################################
###############################################################################################################################################################

  output$valueBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Share",
              icon = icon("stats", lib = "glyphicon"),
              color = "green",
              fill = TRUE)
    }
  )
  
  output$progressBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Value Invested",
              icon = icon("ok-circle", lib = "glyphicon"),
              color = "red",
              fill = TRUE)
    }
  )
  
  output$approvalBox <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", paste0(0, "%")),
              title = "Profit",
              icon = icon("thumbs-up", lib = "glyphicon"),
              color = "yellow",
              fill = TRUE)
    }
  )
  
  output$valueBox1 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Share",
              icon = icon("stats", lib = "glyphicon"),
              color = "green",
              fill = TRUE)
    }
  )
  
  output$progressBox1 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Value Invested",
              icon = icon("ok-circle", lib = "glyphicon"),
              color = "red",
              fill = TRUE)
    }
  )
  
  output$approvalBox1 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", paste0(0, "%")),
              title = "Profit",
              icon = icon("thumbs-up", lib = "glyphicon"),
              color = "yellow",
              fill = TRUE)
    }
  )
  
  output$valueBox2 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Share",
              icon = icon("stats", lib = "glyphicon"),
              color = "green",
              fill = TRUE)
    }
  )
  
  output$progressBox2 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", 0),
              title = "Value Invested",
              icon = icon("ok-circle", lib = "glyphicon"),
              color = "red",
              fill = TRUE)
    }
  )
  
  output$approvalBox2 <- renderInfoBox(
    {
      infoBox(value = tags$p(style = "font-size: 30px;", paste0(0, "%")),
              title = "Profit",
              icon = icon("thumbs-up", lib = "glyphicon"),
              color = "yellow",
              fill = TRUE)
    }
  )
  
###################################################################### COUPLED EVENTS #########################################################################
###############################################################################################################################################################
  
  selected_country_map <- reactive(
    {
      d <- event_data("plotly_click", source = "select")
      if (is.null(d))
      {
        return(NULL)
      }
      else
      {
        index <- as.numeric(d[2]$pointNumber) + 1
        df2()[row.names(df2()) == index, "Country_Name"]
      }
    }
  )
  
  selected_country_bar <- reactive(
    {
      d <- event_data("plotly_click", source = "subset")
      if (is.null(d))
      {
        return(NULL)
      }
      else
      {
        d[["x"]]
        # index <- as.numeric(d[2]$pointNumber) + 1
        # df2()[df2()$Country_Name %in% input$region, row.names(df2()) == index, "Country_Name"]
      }
    }
  )
  
######################################################################## DT TABLES ############################################################################
###############################################################################################################################################################
  
  output$countries <- DT::renderDataTable(
    {
      if (is.null(selected_country_map()))
      {
        Data_() %>%
          group_by(Country_Name, League_Name, Team1, Team2, Event_Datetime) %>%
          summarise(Reports = n()) %>%
          mutate(Date = substr(as.POSIXct(Event_Datetime, format = "%Y-%m-%dT%H:%M:%S"), 1, 10),
                 Hour = substr(as.POSIXct(Event_Datetime, format = "%Y-%m-%dT%H:%M:%S"), 12, 19)) %>%
          select(-Event_Datetime)
      }
      else
      {
        Data_() %>%
          group_by(Country_Name, League_Name, Team1, Team2, Event_Datetime) %>%
          summarise(Reports = n()) %>%
          mutate(Date = substr(as.POSIXct(Event_Datetime, format = "%Y-%m-%dT%H:%M:%S"), 1, 10),
                 Hour = substr(as.POSIXct(Event_Datetime, format = "%Y-%m-%dT%H:%M:%S"), 12, 19)) %>%
          filter(Country_Name %in% selected_country_map()) %>%
          select(-Event_Datetime)
      }
    },
    options = list(pageLength = 12, scrollX = TRUE, scrollY = "430px", columnDefs = list(list(className = 'dt-center', targets = "_all"))), rownames = FALSE)
  
  
######################################################################## OBSERVERS ############################################################################
###############################################################################################################################################################
  
  observe(
    {
      updateSelectInput(session = session, inputId = "country", choices = unique(Data_()[Data_()$Region %in% input$region, "Country_Name"]))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "region", choices = unique(Data_()[, "Region"]))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "bookmarks", choices = Consulta(Query = "SELECT bookmark_name FROM bookmarks WHERE include = 'yes'", Table = "bookmarks"))
    }
  )
  
  observe(
    {
      updateSelectInput(session = session, inputId = "sport", choices = Consulta(Query = "SELECT sport_name FROM sports", Table = "sports"))
    }
  )
  
####################################################### MESSAGES, NOTIFICATIONS AND ALERTS ####################################################################
###############################################################################################################################################################
  output$Messages <- renderMenu(
    {
      messageData <- Consulta(Query = "SELECT * FROM MESSAGES", Table = "messages")
      msgs <- apply(messageData, 1,
                    function(row) 
                    {
                      messageItem(from = row[["sent_by"]], message = row[["message"]])
                    }
      )
      dropdownMenu(type = "messages", .list = msgs)
    }
  )
}