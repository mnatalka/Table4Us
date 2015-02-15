get_global_mean <- function(ratings_matrix) {

	global_mean <- mean(ratings_matrix, na.rm = TRUE)
}

user_baseline_predictor <- function(ratings_matrix, global_mean) {
	
	#create empty vector with names corresponding to user names for holding users offsets from the global mean
	users_baseline_vector <- numeric(length=nrow(ratings_matrix))
	names(users_baseline_vector) <- row.names(ratings_matrix)
		
	for(i in 1:nrow(ratings_matrix)) {
		scores <- ratings_matrix[i,]
		number_rated_items <- sum(!is.na(scores))
		ratings <- scores[!is.na(scores)]
		ratings_offsets <- sum(ratings-global_mean)		
		#add damping term
		baseline <- ratings_offsets/number_rated_items		
		users_baseline_vector[rownames(ratings_matrix)[i]] <- baseline
	}
	
	write.csv(ratings, file = "outputs/baseline_matrix.csv", row.names=TRUE)
	users_baseline_vector
	
}


item_baseline_predictor <- function(ratings_matrix, users_baseline_vector, global_mean) {

	items_baseline_vector <- numeric(length=ncol(ratings_matrix))
	names(items_baseline_vector) <- colnames(ratings_matrix)
	item_offset <- 0
	
	for(i in 1:ncol(ratings_matrix)) {
	
		scores <- ratings_matrix[, i]
		number_rated <- sum(!is.na(scores))
		ratings <- which(!is.na(ratings_matrix[, i]))
		if(number_rated > 0) {
		
			for(j in ratings) {
				item_offset <- item_offset + (ratings_matrix[j, i] - users_baseline_vector[j] - global_mean)
			}					
		baseline <- item_offset/number_rated	
		
		} else {
		baseline <- 0
		}
		
		items_baseline_vector[i] <- baseline
		
		item_offset <- 0

	}

	items_baseline_vector

}

create_baseline_prediction_matrix <- function(ratings_matrix, users_baseline_vector, items_baseline_vector, global_mean) {
	
	#prediction_vector <- numeric()
	
	#fill prediction vector with global mean
	#prediction_vector <- rep(global_mean, ncol(ratings_matrix))
	
	#add item offset for all items
	#prediction_vector <- prediction_vector + items_baseline_vector
	
	#add user offset	
	#prediction_vector <- prediction_vector + users_baseline_vector[user]
	
	#initialise baseline predictor with the global mean
	baseline_prediction_matrix <- matrix(data = global_mean, nrow = nrow(ratings_matrix),ncol = ncol(ratings_matrix))
	
	#add users offsets
	for( i in 1:nrow(ratings_matrix)) {
			baseline_prediction_matrix[i,] <- baseline_prediction_matrix[i,] + items_baseline_vector
	}
	#add items offsets
	for(j in 1:ncol(ratings_matrix)) {
			baseline_prediction_matrix[,j] <- baseline_prediction_matrix[,j] + users_baseline_vector
	}
	
	
	baseline_prediction_matrix
	
}
#not sure if needed

baseline_predictor_to_files <- function() {	
	
	userBase <- userBaselinePredictor()
	write.csv(userBase, file = "UserBaselines.csv", row.names=TRUE)
		
	itemBase <- itemBaselinePredictor(userBase)
	write.csv(itemBase, file = "ItemBaselines.csv", row.names=TRUE)
	
}
