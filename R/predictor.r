#make prediction for all users that have enough ratings
source("R/k_nn.r")
source("R/prediction.r")


	prediction_matrix <- vector()
	my_neighbours <- create_neighbours_list()


	for(user in names(my_neighbours)) {
		user_prediction <- prediction(user)
		prediction_matrix <- rbind(prediction_matrix, user_prediction)
	}

	rownames(prediction_matrix)<-names(my_neighbours)

	write.csv(prediction_matrix, file = "outputs/prediction_matrix.csv", row.names=TRUE)
	
