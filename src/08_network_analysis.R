### Network

library(network)
library(tidyverse)
library(tibble)

load("~/Box Sync/2018 Spring/SoDA 501/FinalProject/agg_elist.RData")
edges <- agg_elist
edges$dist <- NULL
edges <- distinct(edges)
head(edges)

#create node list
origins <- edges %>%
  distinct(origin) %>%
  rename(label = origin)

destinations <- edges %>%
  distinct(dest) %>%
  rename(label = dest)

nodes <- full_join(origins, destinations, by = "label")
nodes <- nodes %>% rowid_to_column("id")
head(nodes)

#create edgelist
per_route <- edges %>%  
  group_by(origin, dest) %>%
  summarise(weight = n()) %>% 
  ungroup()
per_route

edges <- per_route %>% 
  left_join(nodes, by = c("origin" = "label")) %>% 
  rename(from = id)

edges <- edges %>% 
  left_join(nodes, by = c("dest" = "label")) %>% 
  rename(to = id)

edges <- select(edges, from, to, weight)
head(edges)

#build network
#travel_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
#plot(travel_network, vertex.cex = 1, mode = "circle")

#detach(package:network)
#rm(travel_network)
#library(igraph)
#travel_igraph <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)
#plot(travel_igraph, layout = layout_with_graphopt, edge.arrow.size = 0.2)

library(visNetwork)
library(networkD3)
visNetwork(nodes, edges)