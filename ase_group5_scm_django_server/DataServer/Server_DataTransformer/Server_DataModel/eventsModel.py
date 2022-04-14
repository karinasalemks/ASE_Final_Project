import json


class EVENTS:
    """create event objects using the api response"""

    def __init__(self, inputData):
        self.location_name = inputData["event_location_name"]
        self.latitude = inputData["event_location_latitude"]
        self.longitude = inputData["event_location_longitude"]
        self.nearest_bus_stops = inputData["stops"]
        self.events = inputData["events"]

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)
