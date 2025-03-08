
source("code/import_data.R")


mypalette <- colorNumeric(
  palette = "viridis", domain = df$Indice_Contexte,
  na.color = "transparent"
)
mypalette(c(45, 43))

m <- leaflet(df) |> 
  addTiles() |> 
  addPolygons(
    stroke = FALSE, fillOpacity = 0.5,
    smoothFactor = 0.5, color = ~ colorQuantile("YlOrRd", Indice_Contexte)(Indice_Contexte)
  )
m


library(RColorBrewer)
mybins <- c(0.3, 0.4,0.5, 0.6)
mypalette <- colorBin(
  palette = "YlOrBr", domain = df$Indice_Contexte,
  na.color = "transparent", bins = mybins
)
# Prepare the text for tooltips:
mytext <- paste(
  "Prefecture: ", df$shapeName, "<br/>",
  "Indice de contexte: ", round(df$Indice_Contexte, 2),
  sep = ""
) |> 
  lapply(htmltools::HTML)

m <- leaflet(df) |> 
  addTiles() |> 
  addPolygons(
    fillColor = ~ mypalette(Indice_Contexte),
    stroke = TRUE,
    fillOpacity = 0.9,
    color = "white",
    weight = 0.3,
    label = mytext,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "13px",
      direction = "auto"
    )
  ) |> 
  addLegend(
    pal = mypalette, values = ~Indice_Contexte, opacity = 0.9,
    title = "Population (M)", position = "bottomleft"
  )

m