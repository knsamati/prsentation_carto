source("code/import_data.R")

available_features()

Lome <- getbb("Lomé Togo")  

cotonou <- getbb("Cotonou Benin")



Lome_routes <- Lome |> 
  opq() |> 
  add_osm_feature(key = "highway") |> #value = c("motorway", "primary", "secondary")) 
  osmdata_sf()

Lome_ecole <- Lome  |> 
  opq() |> 
  add_osm_feature(key = "amenity",value = "school") |> 
  osmdata_sf()

ggplot() +
  geom_sf(data = Lome_routes$osm_lines,
          inherit.aes = FALSE,
          color = "#666666",
          size = .2,
          alpha = .3)
  



ggplot() +
  geom_sf(data = Lome_routes$osm_lines,
          inherit.aes = FALSE,
          color = "#666666",
          size = .2,
          alpha = .3) +
  geom_sf(data = Lome_ecole$osm_points,
          inherit.aes = FALSE,
          color = "steelblue",
          alpha = .5, 
          size = 1) +
  coord_sf(xlim = c(1.175, 1.31), 
           ylim = c(6.11, 6.21)) +
  theme_void() +
  theme(plot.title = element_text(size = 20, family = "Ubuntu", face = "bold", hjust = 0.5),
        plot.subtitle = element_text(family = "Ubuntu", size = 8, hjust = 0.5, margin = margin(2, 0, 5, 0))) +
  labs(title = "Lomé, La capitale du Togo", subtitle = "Opens Street Map")







