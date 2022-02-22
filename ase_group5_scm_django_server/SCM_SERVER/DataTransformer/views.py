from django.shortcuts import render
from DataTransformer.DataModel.bikeModel import BikeModel
from predictionApp.views import BikePredictor
import pandas as pd
import numpy as np
import json

# Create your views here.
def transformBikeData(inputData):
    # result = {}
    stationData = []
    bikePredictor = BikePredictor()

    for apiResponse in inputData:
        # Call Prediction Engine here
        apiResponse = json.loads(apiResponse)
        recent_list = np.fromstring(bikePredictor.recent_df.loc[int(apiResponse['station_id'])].recentObservations[1:-1],
                                    sep=' ', dtype='int64')
        updated_list = np.empty(20, dtype='int64')
        updated_list[:19] = recent_list[1:]
        updated_list[19] = apiResponse['available_bikes']
        bikePredictor.recent_df.loc[int(apiResponse['station_id'])].recentObservations = updated_list
        predictions = bikePredictor.predictDublinBikes(updated_list, int(apiResponse['station_id'])).tolist()
        predictions.insert(0, apiResponse['available_bikes'])
        apiResponse['available_bikes'] = predictions
        bikeData = BikeModel(apiResponse)
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


def transformData(source="DUBLIN_BIKES", apiResponse={}):
    return DataTransformer.get(source)(apiResponse)
