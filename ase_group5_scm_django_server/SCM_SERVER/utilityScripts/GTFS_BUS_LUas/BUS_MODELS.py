class TRIP:
    def __init__(self,trip_id,entity,start_time,stop_sequences):
        self.trip_id = trip_id
        self.entity = entity
        self.start_time = start_time
        self.stop_sequences = stop_sequences
    

class BUS_STOP:
    """Read stops.txt file and create objects"""
    def __init__(self,stop_id,stop_name,stop_lat,stop_lon):
        self.stop_id = stop_id
        self.name = stop_name
        self.latitude = stop_lat
        self.longitude = stop_lon

class STOPSEQUENCE:
    """Read data from stop_times.txt and 
    aggregate with stop time update data received from API"""
    def __init__(self,stop_sequence_id,bus_stop,arrival_time,departure_time):
        self.stop_sequence_id = stop_sequence_id
        self.bus_stop = bus_stop
        self.arrival_time = arrival_time
        self.departure_time = departure_time
        