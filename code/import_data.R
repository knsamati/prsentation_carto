
#install.packages(c("sf","tidyverse","stars","tmap","leaflet","mapview","ggmap","showtext","viridis","rcartocolor",
#"biscale","cowplot","ggspatial","osmdata","classInt"),dep = TRUE)


## Les packages nécessaires 
library(tidyverse) # manipalulation des données 
library(sf)
library(stars)
library(tmap)
library(leaflet)
library(mapview)
library(ggmap)
library(showtext) 
library(viridis)
library(rcartocolor)
library(biscale)
library(cowplot)
library(ggspatial)
library(osmdata)
library(classInt)
library(ggtext)

####################################### Représentation de polygones


## I .Importation des données dans R

### 1. importation de fonds de cartes

carte <- st_read("data/carte/pays.gpkg")

Togo <- carte |> 
  filter(shapeGroup == "TGO") |> 
  select(-id)

### 1.1 Une première représentation des données

plot(Togo)
plot(st_geometry(Togo), col = "white", border = "black")

st_bbox(Togo)

st_crs(Togo)

### 1.2 Quelques opérations géographiques avec les données 
#sf_use_s2(TRUE)
#superf <- st_area(Togo)
#units::set_units(carte$surf, km^2) 

### 2. importation des données à représenter

taux <- readxl::read_xlsx("data/taux/taux.xlsx")

acled <- readxl::read_xlsx("data/acled/acled.xlsx")

### 3. traitement des données

taux$Prefecture <- str_replace(taux$Prefecture," ","_")
taux$Prefecture <- str_replace(taux$Prefecture,"-","_")
taux$Prefecture <- toupper(taux$Prefecture)

taux <- taux |> 
 mutate(Prefecture = case_when(
   Prefecture== "MÔ" ~ "MO",
   Prefecture== "KPENDJAL_OUEST" ~ "KPENDJAL",
   Prefecture== "OTI_SUD" ~ "OTI",
   Prefecture== "AGOE_NYIVE" | Prefecture == "GOLFE"~ "GOLFE", 
   .default = Prefecture
  ))


Togo$shapeName <- str_replace(Togo$shapeName," ","_")
Togo$shapeName <- str_replace(Togo$shapeName," ","_")
Togo$shapeName <- str_replace(Togo$shapeName,"-","_")
Togo$shapeName <- toupper(Togo$shapeName)

Togo <- Togo |> 
  mutate(shapeName = case_when(
    shapeName=="AKÉBOU" ~ "AKEBOU",
    shapeName=="ANIÉ" ~ "ANIE",
    shapeName=="CINKASSÉ" ~ "CINKASSE",
    shapeName=="TANDJOUARE" ~ "TANDJOARE",
    shapeName=="KPÉLÉ" ~ "KPELE",
    shapeName=="LOME_COMMUNE" ~ "GOLFE",
    shapeName=="PLAINE_DE_MÔ" ~ "MO",
    .default = shapeName
  ))

taux <- taux |> 
  group_by(Prefecture) |> 
  summarise(Indice_Contexte = mean(Indice_Contexte,na.rm = TRUE),
            Taux_rétention = mean(Taux_rétention,na.rm = TRUE),  
            Taux_réussite_BEPC = mean(Taux_réussite_BEPC,na.rm = TRUE),
            Pr_non_redoublants = mean(Pr_non_redoublants,na.rm = TRUE),
            Indice_résultat = mean(Indice_résultat,na.rm = TRUE),
            Efficience = mean(Efficience,na.rm = TRUE))

### 4.Fusion des deux bases des données


df <- Togo |> 
  left_join(taux,by = join_by(shapeName == Prefecture))

### 4.1 Représentation des cartes avec plot

