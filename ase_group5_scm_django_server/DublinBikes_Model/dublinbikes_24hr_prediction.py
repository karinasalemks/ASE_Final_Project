import numpy as np
from sklearn.linear_model import Ridge
from sklearn.preprocessing import MinMaxScaler
from joblib import dump, load
import pandas as pd

# input, X is a list of the 20 most-recent observations, station_ID is the ID of the station.
# Note, station_ID must be an int rather than a string. If you're getting KeyErrors, this is likely the reason.

# Output, Y, a list with predictions for every 5 minutes for the next 24 hours.
def dublinbikes_prediction(X, station_ID):

    # Create a dictionary that can look-up that maxBikes for a station based on it's station_ID
    station_maxBikes_df = pd.read_csv('StationID_Stand.csv')
    maxBikes_dict = station_maxBikes_df.set_index('stationID').to_dict()
    maxBikes = maxBikes_dict['maxBikes'][station_ID]

    # Min-max scaling -> x - min(x) / max(x) - min(x)
    # Since min(x) is always 0, we instead have x/max(x)

    X = X/maxBikes

    print("FUNCTION SCALER")
    print(X)

    # Load the pre-trained model and make predictions.
    model = load('dublinbikes_ridge.joblib')
    Y = model.predict([X])

    # Reverse min-max scaling, and round to nearest integer
    Y = np.round(Y * maxBikes)

    # Return Y[0] since Y is actually a 2-d array, but with only one row. Y[0] is a list.
    return Y[0]
