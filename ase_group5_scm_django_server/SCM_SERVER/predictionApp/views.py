from django.shortcuts import render
import numpy as np
from sklearn.linear_model import Ridge
from joblib import dump, load
import pandas as pd
import os

class BikePredictor:

    def __init__(self) -> None:
        #Generte OS Independent Paths here
        self.staticPath = os.path.join(os.getcwd(),'static')
        self.station_maxbikes_path = os.path.join(self.staticPath,'StationID_Stand.csv')
        self.recent_df_path = os.path.join(self.staticPath,'StationID_Recent_Observations.csv')
        
        #Open all the CSV files here
        self.station_maxBikes_df = pd.read_csv(self.station_maxbikes_path)
        # Fetching recent observations from csv for predictions.
        self.recent_df = pd.read_csv(self.recent_df_path)
        self.recent_df.set_index('stationID', inplace=True)
    
    # Create your views here
    def predictDublinBikes(self,X, station_ID):
        
        # Create a dictionary that can look-up that maxBikes for a station based on it's station_ID
        maxBikes_dict = self.station_maxBikes_df.set_index('stationID').to_dict()
        maxBikes = maxBikes_dict['maxBikes'][station_ID]

        # Min-max scaling -> x - min(x) / max(x) - min(x)
        # Since min(x) is always 0, we instead have x/max(x)
        X = X/maxBikes

        # Load the pre-trained model and make predictions.
        model = load('static/dublinbikes_ridge.joblib')
        Y = model.predict([X])

        # Reverse min-max scaling, and round to nearest integer
        Y = np.round(Y * maxBikes)

        # Cap the predictions at the maxBikes value
        Y[Y > maxBikes] = maxBikes

        # Set all negative observations to 0
        Y[Y < 0] = 0

        # Return Y[0] since Y is actually a 2-d array, but with only one row. Y[0] is a list.
        return Y[0]

    def updateAndCloseFiles(self):
        # Save updated Observations CSV
        self.recent_df.to_csv(self.recent_df_path)




