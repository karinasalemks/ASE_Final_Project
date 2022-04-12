import pandas as pd
import csv

inputFilePath = "Server_DataTransformer/StaticFiles/luasstopnames.csv"
def readSTOPSFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    list_of_stops = {}
    for index, row in data.iterrows():
        each_stops = {}
        each_stops['Latitude'] = row['Latitude']
        each_stops['Longitude'] = row['Longitude']
        each_stops['name'] = row['Stop_English']
        list_of_stops[ row['stop_code']] = each_stops
    return list_of_stops

class Tram:
    def __init__(self, tram_id, src_st, dst_st, duration) -> None:
        self.tram_id = tram_id
        self.src_st = src_st
        self.dst_st = dst_st
        self.duration = duration

luas_stops = readSTOPSFile(inputFilePath)