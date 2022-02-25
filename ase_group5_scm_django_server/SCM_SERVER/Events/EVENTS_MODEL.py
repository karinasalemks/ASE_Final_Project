class EVENTS:
    """create event objects using the api response"""
    def __init__(self,name,date,location_name,latitude, longitude):
        self.name = name
        self.date = date
        self.location_name = location_name
        self.latitude = latitude
        self.longitude = longitude
