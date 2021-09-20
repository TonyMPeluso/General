install.packages("sf")
install.packages("cancensus")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("rsconnect")
install.packages("leaflet")
install.packages("leaflet.extras")
# install.packages("writexl")
# install.packages("lwgeom")
library(sf)
library(cancensus)
options(cancensus.cache_path = "custom cache path")
options(cancensus.api_key = "CensusMapper_XXXXX")
library(tidyverse)
library(ggplot2)
library(rsconnect)
library(leaflet)
library(leaflet.extras)

census_data <- get_census(dataset='CA16', regions=list(PR="35"),
                          vectors=c("inc_hh_median_aftertax"="v_CA16_2398"), level='CT', quiet = TRUE, 
                          geo_format = 'sf', labels = 'short')
CTOttawa <- filter(census_data, CMA_UID == "505")

census_data[!complete.cases(census_data),] 
glimpse(census_data)

bins <- c(0, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 110000, Inf)
pal <- colorBin("RdYlBu", domain = CTOttawa$v_CA16_2397, bins = bins)
labels <- c(CTOttawa$inc_hh_median_aftertax)
leaflet(CTOttawa) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(fillColor = ~pal(inc_hh_median_aftertax),
                color = "white",
                weight = 1,
                opacity = 1,
                fillOpacity = 0.65,
                highlightOptions = highlightOptions(
                    color = "#666", weight = 3, bringToFront = F, opacity = 1),
                label = labels,
                labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"))

