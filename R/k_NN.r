#create list to hold lists of neighbours and they distances for each user

create_neighbours_list <- function(file_name = "outputs/cos_similarity_matrix.csv") {

	similarity_matrix <- read.csv(file_name, row.names=1)
	similarity_matrix <- as.matrix(similarity_matrix,check.names=FALSE)
	
	neighbour_list <- list()
	length(neighbour_list) <- nrow(similarity_matrix)
		
	users_names <- rownames(similarity_matrix)
	names(neighbour_list) <- users_names
	
	for(i in names(neighbour_list)) {
		user_sim <- similarity_matrix[i,]
		names(user_sim)<-rownames(similarity_matrix)
		good <- !is.na(user_sim)
		user_sim <- user_sim[good]
		neighbour_list[[i]] <- user_sim
	}	
     neighbour_list <- neighbour_list[sapply(neighbour_list, length) > 0]
}

