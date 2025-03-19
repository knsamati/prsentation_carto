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

## La représentation graphique en combinant les différents éléments
ggplot() +
  geom_sf(data = Lome_routes$osm_lines,
          inherit.aes = FALSE,
          color = "#666666",
          size = 1,
          alpha = .3) +
  geom_sf(data = Lome_ecole$osm_points,
          inherit.aes = FALSE,
          color = "steelblue",
          alpha = .5, 
          size = 5) +
  coord_sf(xlim = c(1.175, 1.31), 
           ylim = c(6.11, 6.21)) +
  theme_void() +
  labs(title = "Représentation Des routes et des écoles de **<span style ='color:#9d1e1e'>Lomé</span>** à partir des données de **<span style ='color:#666666'>Open Street Map</span>**", subtitle = "Données obtenues à partir du package **osdata**", caption = "Introduction à la représentation Cartographique avec R | R learner Community | Réalisation: Komlan Samati") + 
  theme(text = element_text(size = 12, family = 'Ubuntu', color = "grey40"),
        plot.title = element_markdown(family = 'Ubuntu', size = 25, hjust = 0),
        plot.title.position = "plot",
        plot.subtitle = element_markdown(family = 'Ubuntu', size = 16),
        plot.caption = element_markdown(family = 'Ubuntu', size = 12, hjust = 1),
        plot.caption.position = "plot",
        legend.key.width = unit(2, "lines")) 







