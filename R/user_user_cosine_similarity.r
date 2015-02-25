#user-user adjusted cosine similarity matrix

#library(lsa)

create_similarity_matrix <- function(file_name = "outputs/ratings_matrix.csv") {

	ratings_matrix <- read.csv(file_name, row.names=1)
	ratings_matrix <- as.matrix(ratings_matrix)

	small_matrix <- numeric()
	user_names <- vector()

	#create matrix of ratings for users that have rated more than 5 restaurants
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
		print("Creating for user")
		print(i)
		for (k in 1:nrow(small_matrix))
		{
			if (i != k){
				co_rated_list <- which(complete.cases( small_matrix[i,], small_matrix[k,] ))
				if(length(co_rated_list)>3) {			
					ui <- small_matrix[i,co_rated_list] - users_baseline[row.names(small_matrix)[i]]
					uk <- small_matrix[k,co_rated_list] - users_baseline[row.names(small_matrix)[k]]
					cosine_similarity_matrix[i,k] <- cor(ui,uk)
				}
				else {
						cosine_similarity_matrix[i,k] <- NaN
				}

			}
			else {
			cosine_similarity_matrix[i,k] <- NaN
			}
		}
	}

	write.csv(cosine_similarity_matrix, file = "outputs/cos_similarity_matrix.csv", row.names=TRUE)
	cosine_similarity_matrix
 }