needs(magrittr)
set.seed(512)
#do.call(rep, input) 
load("/Users/ragrawal4/Documents/295b/final_data.Rdata")
accident_data_final$Timestamp <- as.POSIXct(accident_data_final$Timestamp,format = "%Y-%m-%d %H:%M:%S")
smp_size <- floor(0.75 * nrow(accident_data_final))
set.seed(123)
train_ind <- sample(seq_len(nrow(accident_data_final)), size = smp_size)
train <- accident_data_final[train_ind, ]
test <- accident_data_final[-train_ind, ]
train$Timestamp <- as.POSIXct(train$Timestamp,format = "%Y-%m-%d %H:%M:%S")
test$Timestamp <- as.POSIXct(test$Timestamp,format = "%Y-%m-%d %H:%M:%S")

Lat_model <- lm(Latitude ~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Timestamp+Vehicle.Type ,data = train)
Long_model <- lm(Longitude ~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Timestamp+Vehicle.Type ,data = train)

#input[1] <- factor(input[[1]])
#Create predict dataframe using input from user
predict.data <- data.frame(Intersection=factor(input[[1]]),Light_Cond=factor(input[[2]]),Weather=factor(input[[3]]),Road_Surface=factor(input[[4]]),Collision_Type=factor(input[[5]]),Gender=factor(input[[6]]),Violation=factor(input[[7]]),Timestamp=factor(input[[8]]),Vehicle.Type=factor(input[[9]]))

#convert timestamp to POSIXct from factor
predict.data$Timestamp <- as.POSIXct(predict.data$Timestamp, format = "%Y-%m-%d %H:%M:%S")

#predict the latitude and longitude of the accident occurrence location
predict.data$Latitude <- predict(Lat_model, newdata = predict.data,type="response")
predict.data$Longitude <- predict(Long_model, newdata = predict.data,type="response")

#Compute the RMSE value for predicted latitude and longitude
rmse_latitude <- sqrt(mean((predict.data$Latitude- test$Latitude)^2, na.rm = TRUE))
rmse_longitude <- sqrt(mean((predict.data$Longitude- test$Longitude)^2, na.rm = TRUE))

#return (input[1])
#Returning an array of predicted Latitude and longitude along with their RMSE values respectively
return (c(predict.data$Latitude,predict.data$Longitude,rmse_latitude,rmse_longitude))