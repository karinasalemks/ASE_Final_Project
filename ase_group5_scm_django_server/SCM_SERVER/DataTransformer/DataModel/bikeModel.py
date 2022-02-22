class BikeModel:
    # default constructor
    def __init__(self,inputData):
        self.station_id = inputData['station_id']
        self.available_bikes = inputData['available_bikes']
        self.available_bikeStands=inputData['available_bikeStands']
        self.bike_stands = inputData['bike_stands']
        self.harvest_time = inputData['harvest_time']
        self.latitude = inputData['latitude']
        self.longitude = inputData['longitude']
        self.station_name = inputData['station_name']
        self.station_status = inputData['station_status']

    def calculateOccupancyList(self):
        occupancyList = []
        for x in self.available_bikes:
            occupancyList.append(float("{:.3f}".format(x / self.bike_stands)))
        self.occupancy_list = occupancyList

    def to_dict(self):
        result = {}
        result['station_id'] = self.station_id
        result['available_bikes'] = self.available_bikes
        result['available_bikeStands']=self.available_bikeStands
        result['bike_stands'] = self.bike_stands
        result['harvest_time'] = self.harvest_time
        result['latitude'] = self.latitude
        result['longitude'] = self.longitude
        result['station_name'] = self.station_name
        result['station_status'] = self.station_status
        result['occupancy_list'] = self.occupancy_list
        return result