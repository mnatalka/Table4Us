#user-user adjusted cosine similarity matrix

ratings_matrix <- ratings
small_matrix <- numeric()
user_names <- vector()

for(i in 1:nrow(ratings_matrix)) {
	scores <- ratings_matrix[i,]
	number_rated_items <- sum(!is.na(scores))
	if(number_rated_items>5) {
		temp <- ratings_matrix[i,]
		user_names <- rbind(user_names, row.names(ratings_matrix)[i])
		small_matrix <- rbind(small_matrix, temp)
	}
}

row.names(small_matrix) <- user_names

cosine_similarity_matrix  <- matrix(data = NA, nrow = nrow(small_matrix),ncol = nrow(small_matrix))
colnames(cosine_similarity_matrix)<-row.names(small_matrix)
rownames(cosine_similarity_matrix)<-row.names(small_matrix)

for (i in 1:nrow(small_matrix)) {
	for (k in 1:nrow(small_matrix))
    {
		if (i != k){
			co_rated_list <- which(complete.cases( small_matrix[i,], small_matrix[k,] ))
			if(length(co_rated_list)>5) {			
				ui <- small_matrix[i,co_rated_list] - users_baseline[row.names(small_matrix)[i]]
				uk <- small_matrix[k,co_rated_list] - users_baseline[row.names(small_matrix)[k]]
				cosine_similarity_matrix[i,k] <- cosine(ui,uk)
			}
			else {
					cosine_similarity_matrix[i,k] <- NaN
			}

		}
		else {
        cosine_similarity_matrix[i,k] <- 1
		}
    }
}
  
  