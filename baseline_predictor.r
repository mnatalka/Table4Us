library("jsonlite")

source("R/create_ratings_matrix.r")
source("R/user_item_baseline.r")
source("R/user_user_cosine_similarity.r")
source("R/predictor.r")

#create ratings matrix, write it to the file and then read from that file
print("Creating ratings matrix")

create_ratings_matrix()
ratings <- read.csv(file="outputs/ratings_matrix.csv", row.names=1)
ratings <- as.matrix(ratings)

#calculate global mean
print("Calculating global mean")
global_mean <- get_global_mean(ratings)
print("Calculating users baselines")
users_baseline <- user_baseline_predictor(ratings, global_mean)
print("Calculating items baselines")
items_baseline <- item_baseline_predictor(ratings, users_baseline, global_mean)

print("Creating baseline matrix")
baseline_matrix <- create_baseline_prediction_matrix(ratings, users_baseline, items_baseline, global_mean)

print("Creating similarity matrix")
similarity_matrix <- create_similarity_matrix()
