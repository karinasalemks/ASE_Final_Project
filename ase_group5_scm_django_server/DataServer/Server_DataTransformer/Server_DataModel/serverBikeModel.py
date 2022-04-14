import json


class BikeModel:
    # default constructor
    def __init__(self, inputData):
        self.station_id = inputData['station_id']
        self.available_bikes = inputData['available_bikes']
        self.available_bike_stands = inputData['available_bike_stands']
        self.bike_stands = inputData['bike_stands']
        self.harvest_time = inputData['harvest_time']
        self.latitude = inputData['latitude']
        self.longitude = inputData['longitude']
        self.station_name = inputData['station_name']
        self.station_status = inputData['station_status']

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,sort_keys=True, indent=4)
