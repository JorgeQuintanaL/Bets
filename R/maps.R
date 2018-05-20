library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")
library("dplyr")
library("plotly")

WorldData <- map_data("world")
WorldData %>% 
  filter(region != "Antarctica") -> WorldData

df2 <- read.delim(file = "world_codes.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)

Data %>%
  group_by(Country_Name) %>%
  summarise(Reports = n()) %>%
  left_join(x = .,
            y = df2,
            by = "Country_Name") -> df2

ggplot() +
  geom_map(data = WorldData,
           map = WorldData,
           aes(x = long, y = lat, group = group, map_id = region),
           fill = "white",
           colour = "black",
           size = 0.3) +
  geom_map(data = df2,
                  map = WorldData,
                  aes(fill = Reports, map_id = Country_Name),
                  colour = "black",
                  size = 0.5) +
  coord_map("rectangular",
            lat0 = 0,
            xlim = c(-180,180),
            ylim = c(-60, 90)) +
  labs(fill = "Eventos", 
       title = "Numero de Eventos por Pais",
       x = "",
       y="",
       subtitle = "Actividad basada en Bookies",
       caption = "Prueba") +
  theme(legend.position = "right")

plot_geo(df2) %>%
  add_trace(z = ~Reports,
            color = ~Reports,
            colors = "Reds",
            text = ~Country_Name,
            locations = ~Code,
            marker = list(line = list(color = toRGB("grey"), width = 0.5))) %>%
  colorbar(title = "Eventos") %>%
  colorbar(title = "") %>%
  layout(title = "Eventos por Pais",
         geo = list(showframe = FALSE,
                    showcoastlines = TRUE,
                    projection = list(type = "Mercator"),
                    lakecolor = toRGB("white")))
?add_trace
?layout
