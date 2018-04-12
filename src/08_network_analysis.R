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
library(igraph)
travel_igraph <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)
#plot(travel_igraph, layout = layout_with_graphopt, edge.arrow.size = 0.2)

library(visNetwork)
library(networkD3)
visNetwork(nodes, edges)

# network analysis

#average distance (how many edges to reach B from A on average)
mean_distance(travel_igraph, directed=T)
distance <- distances(travel_igraph)
plot(distance)

#degree
degree <- degree(travel_igraph, mode="in")
plot(degree)

# Closeness (centrality based on distance to others in the graph)
#Inverse of the node’s average geodesic distance to others in the network.

closeness <- closeness(travel_igraph, mode="all", weights=NA) 
plot(closeness)
#Betweenness (centrality based on a broker position connecting others)
#Number of geodesics that pass through the node or the edge.

betweenness <- betweenness(travel_igraph, directed=T, weights=NA)
plot(betweenness)
