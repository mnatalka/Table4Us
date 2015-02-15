# computing k-NN for K = 20

#crate matrix to hold 20 nearest neighbours for each user if have them
nearest_neighbours <- matrix(data=NA, nrow=nrow(ratings), ncol=5)


for(i in 1:nrow(ratings)) {
	#print(rownames(ratings)[i])
	if(rownames(ratings)[i] %in% rownames(cosine_similarity_matrix) ){
		temp <- cosine_similarity_matrix[row.names(ratings)[i],]
		print(temp)
		nearest_neighbours[i,] <- head(sort(temp, decreasing=TRUE), 5)
	}


}

