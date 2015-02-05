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


item_baseline_predictor <- function(users_baseline_vector) {

	items_baseline_vector <- numeric(length=ncol(ratingsMatrix))
	names(itemsBaseline) <- colnames(ratingsMatrix)
	itemOffset <- 0
	
	for(i in 1:ncol(ratingsMatrix)) {
		scores <- ratingsMatrix[,i]
		numRated <- sum(!is.na(scores))
		ratings <- which(!is.na(ratingsMatrix[,i]))
		
		if(numRated>0) {
				for(j in ratings) {
					itemOffset <- itemOffset + (ratingsMatrix[j,i] - usersBaseline[j] - globalMean)
				}
		
				baseline <- itemOffset/numRated
		}else{
		baseline <- 0
		}
		
		itemsBaseline[i] <- baseline
		
		itemOffset <- 0

	}

	itemsBaseline

}