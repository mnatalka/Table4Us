library("jsonlite")

source("R/create_ratings_matrix.r")
source("R/user_item_baseline.r")
#source("R/user_user_cosine_similarity.r")

#create ratings matrix, write it to the file and then red from that file
create_ratings_matrix()
ratings <- read.csv(file="outputs/ratings_matrix.csv", row.names=1)
ratings <- as.matrix(ratings)

#calculate global mean
global_mean <- get_global_mean(ratings)

users_baseline <- user_baseline_predictor(ratings, global_mean)

items_baseline <- item_baseline_predictor(ratings, users_baseline, global_mean)

baseline_matrix <- create_baseline_prediction_matrix(ratings, users_baseline, items_baseline, global_mean)
