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

luas_stops = readSTOPSFile(inputFilePath)