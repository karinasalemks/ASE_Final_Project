import json
class EVENTS:
    """create event objects using the api response"""
    def __init__(self, inputData):
        self.name = inputData["event_name"]
        self.date = inputData["event_date_time"]
        self.location_name = inputData["event_location_name"]
        self.latitude = inputData["event_location_latitude"]
        self.longitude = inputData["event_location_longitude"]

    # method to convert events model to json
    # https://stackoverflow.com/questions/3768895/how-to-make-a-class-json-serializable :P
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,sort_keys=True, indent=4)

