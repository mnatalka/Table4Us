library("jsonlite")

source("R/create_ratings_matrix.r")
source("R/user_item_baseline.r")

#ratings <- create_ratings_matrix()

#global_mean <- get_global_mean(ratings)

#users_baseline <- user_baseline_predictor(ratings, global_mean)

#items_baseline <- item_baseline_predictor(ratings, users_baseline, global_mean)

user_predict <- baseline_redictor_for_user(ratings, users_baseline, items_baseline, "monken80", global_mean)

#display top 10 choices

head(sort(user_predict, decreasing=TRUE), 10)