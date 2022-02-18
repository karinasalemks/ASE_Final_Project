from pickle import STOP
import pandas as pd
from BUS_MODELS import BUS_STOP

inputFilePath = "data/stops.csv"

def readSTOPSFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    list_of_stops = {}
    for index,row in data.iterrows():
        stop_id = row['stop_id']
        stop_name = row['stop_name'].split(", stop ")[0]
        stop_lat=row['stop_lat']
        stop_lon=row['stop_lon']
        newStop = BUS_STOP(stop_id,stop_name,stop_lat,stop_lon)
        list_of_stops[stop_id] = newStop
    return list_of_stops

bus_stops = readSTOPSFile(inputFilePath)
print(bus_stops[0].name)
