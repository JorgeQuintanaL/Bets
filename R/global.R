rm(list = ls())
library("shinydashboard")
library("httr")
library("jsonlite")
library("dplyr")
library("anytime")
library("tidyr")
library("ggplot2")
library("DT")
library("plotly")
setwd("~/Documents/GitHub/Bets/")

Consulta <- function(Query, Table)
{
  library("RPostgreSQL")
  library("digest")
  tryCatch(
    {
      drv <- dbDriver("PostgreSQL")
      MyConnection <- dbConnect(drv,
                                dbname = "bets",
                                host = "localhost",
                                port = 5432,
                                user = "postgres",
                                password = "J0RG3qu1nt@n@")
      
      if (dbExistsTable(MyConnection, Table))
      {
        Data <- dbGetQuery(conn = MyConnection, statement = Query)
      }
      dbDisconnect(MyConnection)
      return(Data) 
    }, error = function(e) {print("Error al conectarse con la base de datos.")}
  )
}
