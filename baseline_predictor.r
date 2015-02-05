library("jsonlite")

source("R/create_ratings_matrix.r")
source("R/user_item_baseline.r")

#ratings <- create_ratings_matrix()

global_mean <- get_global_mean(ratings)