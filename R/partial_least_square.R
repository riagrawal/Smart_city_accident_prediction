needs(magrittr)
set.seed(512)
# install.packages("pls", repos="http://cran.rstudio.com/")
needs(pls)
#Spliting data frame into train and test data sets for prediction
load("/Users/ragrawal4/Documents/295b/final_data.Rdata")
accident_data_final$Timestamp <- as.POSIXct(accident_data_final$Timestamp,format = "%Y-%m-%d %H:%M:%S")
smp_size <- floor(0.75 * nrow(accident_data_final))
set.seed(123)
train_ind <- sample(seq_len(nrow(accident_data_final)), size = smp_size)
train <- accident_data_final[train_ind, ]
test <- accident_data_final[-train_ind, ]
train$Timestamp <- as.POSIXct(train$Timestamp,format = "%Y-%m-%d %H:%M:%S")
test$Timestamp <- as.POSIXct(test$Timestamp,format = "%Y-%m-%d %H:%M:%S")

##Training the Priciple component regression to predict two values (Latitude and longitude)
plsr_model_lat <- plsr(Latitude ~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Timestamp+Vehicle.Type, data=train, validation="CV")
plsr_model_long <- plsr(Longitude ~ Intersection+Light_Cond+Weather+Road_Surface+Collision_Type+Gender+Violation+Timestamp+Vehicle.Type, data=train, validation="CV")

#create data frame and append it to test data frame
new.data <- data.frame("Street"="ABORN ST",Intersection=factor(input[[1]]),Light_Cond=factor(input[[2]]),Weather=factor(input[[3]]),Road_Surface=factor(input[[4]]),Collision_Type=factor(input[[5]]),Gender=factor(input[[6]]),Violation=factor(input[[7]]),Timestamp=factor(input[[8]]),Vehicle.Type=factor(input[[9]]),Latitude=37.42219,Longitude=-121.9641,Age=23)

#add new frame to existing test data frame
test <- rbind(test,new.data)

# make predictions
lat_predictions <- predict(plsr_model_lat,test , ncomp=6)
long_predictions <- predict(plsr_model_long, test, ncomp=6)

#calculate rmse
plsr_rmse_latitude <- sqrt(mean((test$Latitude - lat_predictions)^2,na.rm = TRUE))
##rmse_latitude -  0.04184836
plsr_rmse_longitude <- sqrt(mean((test$Longitude - long_predictions)^2,na.rm = TRUE))  
##rmse_longitude - 0.04928423

#Returning an array of predicted Latitude and longitude along with their RMSE values respectively
return (c(lat_predictions[nrow(lat_predictions)],long_predictions[nrow(lat_predictions)],plsr_rmse_latitude,plsr_rmse_longitude))



