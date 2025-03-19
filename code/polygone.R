source("code/import_data.R")

### représentation avec base R

plot(df["Taux_rétention"],main = "Carte de retention")

### 4.2 Représentation des cartes avec ggplot

### couleur par défaut de ggplot

ggplot(df) +
  geom_sf(aes(fill = Indice_Contexte),color = "white", size = 0.1) +
  theme_void()

### viridis

ggplot() +
  geom_sf(data = df,aes(fill = Indice_Contexte),color = "white", size = 0.1) +
  scale_fill_viridis(option = "magma",alpha = 0.8,direction = -1, name = "Contexte") +
  theme_void()

### rcartocolor

ggplot() +
  geom_sf(data = df,aes(fill = Indice_Contexte), color = "white", size = 0.1) +
  scale_fill_carto_c(type = "quantitative", palette = "SunsetDark", direction = -1,name = "Conetxte") +
  theme_void()

### buble map

sf_use_s2(FALSE)
carte_centroid <- st_centroid(Togo, of_largest_polygon = T)
df2 <- carte_centroid |> 
  left_join(taux,by = join_by(shapeName == Prefecture))

library(camcorder)

gg_record(
  dir = "data",
  device = "png",
  width = 70,
  height = 70,
  unit = "cm",
  dpi = 500
)


ggplot() +
  geom_sf(data = df, fill = "white") +
  geom_sf(data = df2,aes(size = Indice_Contexte),color = "#9d1e1e") +
  scale_size(range = c(0, 8),name = "Conetxte" ) +
  labs(title = "Représentation des Indices de **<span style ='color:#9d1e1e'>Contexte Moyen</span>** des préfectures <br> à partir des contextes des écoles", subtitle = "Données simulées à partir des données de contexte des écoles issues tableaux de bord écoles", caption = "Introduction à la représentation Cartographique avec R | R learner Community | Réalisation: Komlan Samati")+
  theme_void() +
  theme(text = element_text(size = 12, family = 'Ubuntu', color = "grey40"),
        plot.title = element_markdown(family = 'Ubuntu', size = 25, hjust = 0),
        plot.title.position = "plot",
        plot.subtitle = element_markdown(family = 'Ubuntu', size = 16),
        plot.caption = element_markdown(family = 'Ubuntu', size = 12, hjust = 1),
        plot.caption.position = "plot",
        legend.key.width = unit(2, "lines")
  )

### 4.3 Représentation avec tmap


tm_shape(df) +
  tm_polygons("Indice_Contexte") +
  tm_layout(frame = FALSE) 

tmap_mode("view")
tm_shape(df) +
  tm_polygons(c("Indice_Contexte", "Indice_résultat")) +
  tm_facets(sync = TRUE, ncol = 2)


### 4.4 Représentation bivariée

# créer les classes
data <- bi_class(df,
                 x = Indice_Contexte, 
                 y = Indice_résultat, 
                 style = "quantile", dim = 4)

# Créer la carte
map <- ggplot() +
  geom_sf(data = data, mapping = aes(fill = bi_class), color = "white", size = 0.1, show.legend = FALSE) +
  labs(caption = "Introduction à la représentation Cartographique avec R | R learner Community | Réalisation: Komlan Samati")+
  bi_scale_fill(pal = "GrPink", dim = 3) +
  bi_theme()

# la légende
legend <- bi_legend(pal = "GrPink",
                    dim = 3,
                    xlab = "Context",
                    ylab = "Resultat",
                    size = 12)
# rassembler le tout

# combine map with legend
finalPlot <- ggdraw() +
  draw_plot(map, 0, 0, 1, 1) +
  draw_plot(legend, 0.2, .65, 0.2, 0.2)

finalPlot


### Ajoute des éléments à une carte

ggplot(df) +
  geom_sf(aes(fill = Indice_Contexte),color = "white", size = 0.1) +
  geom_sf_text(aes(label = round(Indice_Contexte*100,2)),size = 2,family = "sans") +
  annotation_scale(location = "tl") +
  annotation_north_arrow(location = "bl", which_north = "true") +
  theme_void()
