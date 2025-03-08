source("code/import_data.R")


Niger <- carte |> 
  filter(shapeGroup == "NER") |> 
  select(-id)


acled <- acled |>
  st_as_sf( coords = c("longitude", "latitude")) |> 
  st_set_crs(st_crs(Niger)) |> 
  filter(country == "Niger")


### 1. Représentation avec Base de R
plot(st_geometry(Niger), col = "white", border = "black")
plot(st_geometry(acled), add = TRUE,col = "skyblue")

### 2. Représentation avec ggplot

ggplot() +
  geom_sf(data = Niger,fill = "white",col = "gray",size=2) +
  geom_sf(data = acled,aes(size = fatalities)) +
  scale_size(range = c(0,5),name = "Nbre de morts") +
  theme_void()+
  facet_wrap(~event_type)

### 3. Représentation avec Tmap

tm_shape(Niger) +
  tm_polygons() +
  tm_shape(acled) +
  tm_symbols(col = "event_type", size = "fatalities") +
  tm_layout(frame = FALSE)

tm_shape(Niger) +
  tm_polygons() +
  tm_shape(acled) +
  tm_symbols(col = "event_type", size = "fatalities") +
  tm_layout(frame = FALSE) +
  tm_graticules() +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scalebar(breaks = c(0, 100, 200), text.size = 1, position = c("left", "top")) +
  tm_title("Données Acled du Niger")
