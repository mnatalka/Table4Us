get_global_mean <- function(ratings_matrix) {

	global_mean <- mean(as.matrix(ratings_matrix), na.rm = TRUE)

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
	
	users_baseline_vector
	
}


item_baseline_predictor <- function(ratings_matrix, users_baseline_vector, global_mean) {

	items_baseline_vector <- numeric(length=ncol(ratings_matrix))
	names(items_baseline_vector) <- colnames(ratings_matrix)
	item_offset <- 0
	
	for(i in 1:2) {#ncol(ratings_matrix)) {
	
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