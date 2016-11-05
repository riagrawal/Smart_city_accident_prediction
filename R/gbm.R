needs(gbm)
needs(magrittr)
set.seed(512)
#do.call(rep, input) 
load("/Users/ragrawal4/Documents/295b/final_data.Rdata")
#accident_data_final$Timestamp <- as.POSIXct(accident_data_final$Timestamp,format = "%Y-%m-%d %H:%M:%S")
smp_size <- floor(0.75 * nrow(accident_data_final))
set.seed(123)
train_ind <- sample(seq_len(nrow(accident_data_final)), size = smp_size)
train <- accident_data_final[train_ind, ]
test <- accident_data_final[-train_ind, ]

##Replace N/A values by some default value
train$Latitude[is.na(train$Latitude)] <- 37.36769
train$Longitude[is.na(train$Longitude)] <- -121.9025

lat_gbm_model <- gbm(Latitude~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Vehicle.Type,train,distribution = "gaussian",n.trees = 1000, bag.fraction = 0.75)
long_gbm_model <- gbm(Longitude~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Vehicle.Type,train,distribution = "gaussian",n.trees = 1000, bag.fraction = 0.75)

#Create predict dataframe using input from user
predict.data <- data.frame(Intersection=factor(input[[1]]),Light_Cond=factor(input[[2]]),Weather=factor(input[[3]]),Road_Surface=factor(input[[4]]),Collision_Type=factor(input[[5]]),Gender=factor(input[[6]]),Violation=factor(input[[7]]),Vehicle.Type=factor(input[[9]]))

#predict the latitude and longitude of the accident occurrence location
predict.data$Latitude <- predict(lat_gbm_model, newdata = predict.data,n.trees = 1000)
predict.data$Longitude <- predict(long_gbm_model, newdata = predict.data,n.trees = 1000)

#Compute the RMSE value for predicted latitude and longitude
rmse_latitude <- sqrt(mean((predict.data$Latitude- test$Latitude)^2, na.rm = TRUE))
rmse_longitude <- sqrt(mean((predict.data$Longitude- test$Longitude)^2, na.rm = TRUE))

#return (input[1])
#Returning an array of predicted Latitude and longitude along with their RMSE values respectively
return (c(predict.data$Latitude,predict.data$Longitude,rmse_latitude,rmse_longitude))