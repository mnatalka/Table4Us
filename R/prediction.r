# make predic

#calculate each user mean rating
users_means <- rowMeans(ratings,na.rm=TRUE)



prediction <- function(user) {

#get neighbourhood of a user
test_user <- my_neighbours[[user]]

#get top 10 neighbours 
test_user <- test_user[order(-test_user)[1:10]]
test_user <- test_user[!is.na(test_user)]

#get users ratings
user_ratings <- ratings[user,]
#create prediction vector for user and fill it with known user ratings
prediction_matrix <- user_ratings

ratings_matrix <- vector()
row_names <- vector()

#create vector with values if similarities with neighbours
similarity_vector <- unlist(test_user)

	for(name in names(test_user)) {
			neighbor_ratings <- ratings[name,] - users_means[name]	
			ratings_matrix <-rbind(ratings_matrix, neighbor_ratings)
			row_names <- rbind(row_names, name)
	}

	#add users id to row names and replace missing values with zeros
	rownames(ratings_matrix) <- row_names
	ratings_matrix[is.na(ratings_matrix)] <- 0

	#make predictions for each restaurant
	for(restaurant in names(user_ratings)) {
		my_list <- which(ratings_matrix[,restaurant]!=0)
		sim <- similarity_vector[my_list]
		denom <- sum(sim)
		cros <- crossprod(ratings_matrix[,restaurant],similarity_vector)
		prediction_matrix[restaurant] <- users_means[user] + cros/denom
		
	}
	
	prediction_no_repeat <- prediction_matrix
	rated <- !is.na(user_ratings)
	prediction_no_repeat[rated] <- NaN
	
	prediction_no_repeat
	#print(top_10)
	#print(top_10_predict)
	#print(prediction_matrix)

}

