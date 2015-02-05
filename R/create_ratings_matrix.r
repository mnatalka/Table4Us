#Function to create the user-item ratings matrix


create_ratings_matrix <- function(reviewsFile = "data/reviewJson2.json", restaurantsFile = "data/restJson2.json") {

reviews <- fromJSON(reviewsFile)
reviews <- reviews[,c("BusinessID","UserID","stars")]
users <- unique(reviews[,"UserID"])
 
restaurants <- fromJSON(restaurantsFile)
restaurants <- restaurants[,c("name", "BusinessID")]
restaurants <- unique(restaurants[,"BusinessID"])

ratings <- matrix(data = NA,nrow = length(users),ncol = length(restaurants))

rownames(ratings) <- users
colnames(ratings) <- restaurants

 for ( i in 1:nrow(reviews)) {
    
    ratings[reviews[i,"UserID"], reviews[i,"BusinessID"]] <- as.numeric(reviews[i,"stars"])
 }

write.csv(ratings, file = "outputs/RatingMatrix.csv", row.names=TRUE)

ratings

}