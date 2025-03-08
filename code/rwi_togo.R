library(tidyverse)
library(sf)
library(ggtext)
library(rcartocolor)
library(patchwork)
library(cowplot)
library(rcartocolor)

map <- st_read("data/donnees_geo/tgo_admbnda_adm3_inseed_20210107.shp")

df <- read_csv("data/tgo_relative_wealth_index.csv") |> 
  st_as_sf( coords = c("longitude", "latitude")) |> 
  st_set_crs(st_crs(map))

df <- st_intersection(map,df)


df |> 
  group_by(ADM3_FR) |> 
  summarise(rwic = mean(rwi)) |> 
  st_set_geometry(NULL) |>
  right_join(map) -> df

map |> 
  left_join(df) -> map


ggplot() +
  geom_sf(data = map, aes(fill = rwic),colour = NA,size = 0.25) + 
  scale_fill_carto_c(type = "quantitative", palette = "SunsetDark",
                     na.value = "white", direction = 1, limits = c(-0.78, 1.44),
                     breaks = seq(-0.8, 1.5, 0.4),name = "RWI") +
  guides(fill = guide_colourbar(title.position = "top")) +
  theme_void() +
  theme(text = element_text(size = 12, family = 'Ubuntu', color = "grey40"),
        plot.title = element_markdown(family = 'Ubuntu', size = 28, hjust = 0),
        plot.title.position = "plot",
        plot.subtitle = element_markdown(family = 'Ubuntu', size = 11),
        plot.caption.position = "plot",
        plot.caption = element_markdown(hjust = 0.5),
        legend.direction = "horizontal",
        legend.key.width = unit(2, "lines"),
        legend.position = "bottom"
  ) +
  labs(caption = "#30MapsChallenge 2023 | Source des Données: <span style='color: #E34F6F;'><b>Data for Good | META</b></span> | Réalisation: Komlan Samati") + 
  geom_richtext(aes(x = -1.600285, y = 9.775648), label = "**<span style ='color:#E34F6F'>RWI</span>**", family = "Ubuntu", size = 10,
                label.colour = NA, fill = NA, hjust = 0) +
  geom_richtext(aes(x = -1.600285,y = 8.983720,label = "**<span style ='color:#E34F6F'>Le RWI <span style ='color:#E34F6F'>(Relative Wealth Index)**</span> <br> donne une idée sur <span style ='color:#E34F6F'>**la pauvrété** </span> <br> au niveau geographie assez <br> desaggragé comme ici au niveau <br> 
                    <span style ='color:#E34F6F'>**des catons**</span>.<br> <br>
                    Le canton de <span style ='color:#E34F6F'> **Gnoaga**</span> dans <br>
                    la région des <span style ='color:#E34F6F'>**Savanes**</span> a le RWI le plus <br>
                    faible et le canton <span style ='color:#E34F6F'>**d'Aflao-Gakli**</span> dans <br>
                    le <span style ='color:#E34F6F'>**Grand-Lomé**</span> a le RWI le plus élévé.
                    "), 
                family = "Ubuntu", size = 3.5,label.colour = NA, fill = NA, lineheight = 1.2, hjust = 0) +
  geom_curve(data = map |> filter(rwic == -0.774), 
             aes(xend = -0.046842, x = 0.591053 ,
                 yend = 11.109828 , y = 11.3643 ),
             arrow = grid::arrow(length = unit(0.3, 'lines')), 
             curvature = 0.35, angle = 30,color = 'gray40') +
  geom_richtext(data = map |> filter(rwic == -0.774),aes(x = 0.591053, y = 11.3643, label = paste0(ADM3_FR," | ","**<span style ='color:#7C1D6F'>-0.774</span>**")),
                hjust = 0, vjust = 0.5, family = 'Ubuntu', color = 'gray40', size = 3.5,alpha = 0.7) +
  geom_curve(data = map |> filter(rwic == 1.43), 
             aes(xend = 1.208602, x = 1.078394 ,
                 yend = 6.189449, y = 6.045714 ),
             arrow = grid::arrow(length = unit(0.5, 'lines')), 
             curvature = 0.35, angle = 30,color = 'gray40') +
  geom_richtext(data = map |> filter(rwic == 1.43),
                aes(x = 1.078394, y = 6.045714,label = paste0(ADM3_FR," | ","**<span style ='color:#7C1D6F'>1.43</span>**")),
                hjust = 1, vjust = 0.5, family = 'Ubuntu',color = 'gray40', size = 3.5,alpha = 0.7)

ggsave("jour2.png", bg = "white", dpi = 600, height = 10, width = 10)

