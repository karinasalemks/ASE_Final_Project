from django.shortcuts import render
from DataTransformer.DataModel.bikeModel import BikeModel
from predictionApp.views import BikePredictor
import pandas as pd
import numpy as np

# Create your views here.
def transformBikeData(inputData,isPrimarySource):
    result = {}
    stationData = []

    bikePredictor = BikePredictor()
    
    if isPrimarySource:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['station_id'])
            
            #Call Prediction Engine here
            recent_list = np.fromstring(bikePredictor.recent_df.loc[int(result['station_id'])].recentObservations[1:-1], sep=' ', dtype='int64')
            updated_list = np.empty(20, dtype='int64')
            updated_list[:19] = recent_list[1:]
            updated_list[19] = apiResponse['available_bikes']
            bikePredictor.recent_df.loc[int(result['station_id'])].recentObservations = updated_list
            predictions = bikePredictor.predictDublinBikes(updated_list,int(result['station_id'])).tolist()
            predictions.insert(0,apiResponse['available_bikes'])  
            result['available_bikes'] = predictions
            
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands']=apiResponse['available_bike_stands']
            #TODO: harvest_time is in timestamp.So do conversion to epochTime as required.
            result['harvest_time'] = apiResponse['harvest_time']
            result['latitude'] = apiResponse['latitude']
            result['longitude'] = apiResponse['longitude']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            bikeData = BikeModel(result)
            bikeData.calculateOccupancyList()
            stationData.append(bikeData)
    else:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['number'])
            
            #Call Prediction Engine here
            recent_list = np.fromstring(bikePredictor.recent_df.loc[int(result['station_id'])].recentObservations[1:-1], sep=' ', dtype='int64')
            updated_list = np.empty(20, dtype='int64')
            updated_list[:19] = recent_list[1:]
            updated_list[19] = apiResponse['available_bikes']
            bikePredictor.recent_df.loc[int(result['station_id'])].recentObservations = updated_list
            predictions = bikePredictor.predictDublinBikes(updated_list,int(result['station_id'])).tolist()
            predictions.insert(0,apiResponse['available_bikes'])  
            result['available_bikes'] = predictions

            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands']=apiResponse['available_bike_stands']
            result['harvest_time'] = apiResponse['last_update']
            result['latitude'] = apiResponse['position']['lat']
            result['longitude'] = apiResponse['position']['lng']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            bikeData = BikeModel(result)
            bikeData.calculateOccupancyList()
            stationData.append(bikeData)
    
    bikePredictor.updateAndCloseFiles()

    return stationData
    
def transformLUASData(apiResponse):
    return "Success"

def transformBUSData(apiResponse):
    return "Success"

def transformEventsData(apiResponse):
    return "Success"

DataTransformer = {
    "DUBLIN_BIKES": transformBikeData,
    "DUBLIN_BUS": transformBUSData,
    "DUBLIN_LUAS": transformLUASData,
    "DUBLIN_EVENTS": transformEventsData,
}

def transformData(source="DUBLIN_BIKES",apiResponse={},isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse,isPrimarySource)




