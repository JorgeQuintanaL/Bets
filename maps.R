library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")
library("dplyr")
library("plotly")

WorldData <- map_data("world")
WorldData %>% 
  filter(region != "Antarctica") -> WorldData

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
df <- df[, c(1, 3)]
names(df) <- c("Country_Name", "Code")

Data %>%
  group_by(Country_Name) %>%
  summarise(Reports = n()) -> df2

df %>%
  left_join(x = .,
            y = df2,
            by = "Country_Name") -> df2
ggplot() +
  geom_map(data = WorldData,
           map = WorldData,
           aes(x = long, y = lat, group = group, map_id = region),
           fill = "#00CC66",
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
  labs(fill = "Temperature", 
       title = "Temperature",
       x = "",
       y="",
       subtitle = "Celsius Degrees",
       caption = "Prueba") +
  theme(legend.position = "bottom")
  # scale_fill_gradient2(low = "black", mid = "white", high = "red", midpoint = 0)

plot_geo(df2) %>%
  add_trace(z = ~Reports,
            color = ~Reports,
            colors = 'Blues',
            text = ~Country_Name,
            locations = ~Code,
            marker = list(line = list(color = toRGB("grey"), width = 0.5))) %>%
  colorbar(title = 'GDP Billions US$', tickprefix = '$') %>%
  layout(title = "Eventos por Pais",
         geo = list(showframe = FALSE,
                    showcoastlines = TRUE,
                    projection = list(type = 'Mercator')))
