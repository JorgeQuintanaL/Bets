Extrae <- function(List, DataFrame, To_Keep, Names, Nested)
{
  if (Nested)
  {
    iter1 <- length(eval(parse(text = substr(x = as.character(List), start = 1, stop = nchar(as.character(List)) - 7))))
    iter2 <- length(eval(parse(text = List)))
    diff <- setdiff(strsplit(as.character(List), "")[[1]], strsplit(substr(x = as.character(List), start = 1, stop = nchar(as.character(List)) - 7), "")[[1]])
    diff[length(diff)]
    res <- lapply(seq(from = 1, to = iter1, by = 1),
                  function(x)
                  {
                    lapply(seq(from = 1, to = iter2, by = 1),
                           function(y)
                           {
                             tryCatch(
                               {
                                 eval(parse(text = paste0(substr(x = as.character(List), start = 1, stop = nchar(as.character(List)) - 7), "[[", y, "]]$", diff[length(diff)], "[[", y, "]]"))) %>%
                                   unnest() %>%
                                   select(which(colnames(.) %in% To_Keep)) -> Aux
                                 names(Aux) <- Names
                                 DataFrame <<- rbind(DataFrame, Aux)
                               }, error = function(e) {print("There are some Events without Markets")}
                             )
                           }
                    )
                  }
    )
    return(DataFrame)
    rm(list = "res")
  }
  else
  {
    iter <- length(List)
    res <- lapply(seq(from = 1, to = iter, by = 1),
                  function(x)
                  {
                    tryCatch(
                      {
                        List[[x]] %>%
                          unnest() %>%
                          select(which(colnames(.) %in% To_Keep)) -> Aux
                        names(Aux) <- Names
                        DataFrame <<- rbind(DataFrame, Aux)
                      }, error = function(e)
                      {
                        print("There are some Events without Markets")
                      }
                    )
                  }
    )
    return(DataFrame)
    rm(list = "res")
  }
}

To_Keep <- c("I", "N", "I1", "N1")
Names <- c("Sport_ID", "Sport_Name", "Region_ID", "Region_Name")
Paises <- data.frame(Sport_ID = numeric(),
                     Sport_Name = character(),
                     Region_ID = numeric(),
                     Region_Name = character())
Paises <- Extrae(List = "JSON_stream$S", DataFrame = Paises, To_Keep = To_Keep, Names = Names, Nested = FALSE)

To_Keep <- c("I", "N", "I1", "N1")
Names <- c("Region_ID", "Region_Name", "League_ID", "League_Name")
Ligas <- data.frame(Region_ID = numeric(),
                    Region_Name = character(),
                    League_ID = numeric(),
                    League_Name = character())
Ligas <- Extrae(List = "JSON_stream$S[[1]]$C", DataFrame = Ligas, To_Keep = To_Keep, Names = Names, Nested = FALSE)

To_Keep <- c("I", "N", "I1", "DT", "BKS", "T1", "T2", "T1I", "T2I", "SC")
Names <- c("League_ID", "League_Name", "Event_ID", "Event_Datetime", "Number_Bookies", "Team1", "Team2", "Team1_ID", "Team2_ID", "Score") 
Eventos <- data.frame(League_ID = numeric(),
                      League_Name = character(),
                      Event_ID = numeric(),
                      Event_Datetime = character(),
                      Number_Bookies = numeric(),
                      Team1 = character(),
                      Team2 = character(),
                      Team1_ID = numeric(),
                      Team2_ID = numeric(),
                      Score = character())
Eventos <- Extrae(List = "JSON_stream$S[[1]]$C[[1]]$L", DataFrame = Eventos, To_Keep = To_Keep, Names = Names, Nested = FALSE)

To_Keep <- c("I", "DT", "BKS", "T1", "T2", "T1I", "T2I", "SC", "K", "H")
Names <- c("Event_ID", "Event_Datetime", "Number_Bookies", "Team1", "Team2", "Team1_ID", "Team2_ID", "Score", "Market_Code", "Market_Arg") 
Mercados <- data.frame(League_ID = numeric(),
                       League_Name = character(),
                       Event_ID = numeric(),
                       Event_Datetime = character(),
                       Number_Bookies = numeric(),
                       Team1 = character(),
                       Team2 = character(),
                       Team1_ID = numeric(),
                       Team2_ID = numeric(),
                       Score = character(),
                       Market_Code = numeric(),
                       Market_Arg = numeric())
Mercados <- Extrae(List = "JSON_stream$S[[1]]$C[[1]]$L[[1]]$E", DataFrame = Mercados, To_Keep = To_Keep, Names = Names, Nested = TRUE)