from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData
import requests
from Server_DataTransformer.Server_DataModel.busModel import bus_stops
from Server_DataTransformer.Server_DataModel.tramModel import Tram
import xml.etree.ElementTree as ET
import time
from numpy import append
import pandas as pd
from datetime import datetime
from datetime import timedelta
import os


def getBikeData(request):
    # dummy logic to determine the api source, it needs a change
    endpoint = None
    isPrimarySource = None
    from random import randint
    value = randint(1, 100)
    if value % 2 == 0:
        endpoint = Endpoints.DUBLIN_BIKES_API['PRIMARY']
        isPrimarySource = True
    else:
        endpoint = Endpoints.DUBLIN_BIKES_API['SECONDARY']
        isPrimarySource = False

    # getting data from bike live data source
    response = requests.get(endpoint)
    dublinBikesData = transformData(
        apiResponse=response.json(), isPrimarySource=isPrimarySource)
    return JsonResponse(dublinBikesData, safe=False)


def getBusData(request):
    response = requests.get(
        Endpoints.DUBLIN_BUSES_API["PRIMARY"], headers=Endpoints.DUBLIN_BUS_HEADER)
    if (response.status_code == 200):
        dublinBusData = transformData(
            source="DUBLIN_BUS", apiResponse=response.json())
        return JsonResponse(dublinBusData, safe=False)
    else:
        print(response.status_code)


def getBusStops(request):
    returnStopList = {}
    for bus_stop in bus_stops.items():
        stop_id, busStopJson = bus_stop[1].toJSON()
        returnStopList[stop_id] = busStopJson
    return JsonResponse(returnStopList, safe=False)


# 60 Kw/h for 120 minutes
UNITS_PER_MIN = 0.5  # Units:Kw/h

# static data for luas
luasStops = ["The Point", "Spencer Dock", "Mayor Square - NCI", "George's Dock", "Connolly", "BusÃ¡ras", "Abbey Street",
             "Jervis",
             "Four Courts", "Smithfield", "Museum", "Heuston", "James's", "Fatima", "Rialto", "Suir Road",
             "Goldenbridge", "Drimnagh", "Fettercairn",
             "Cheeverstown", "Citywest Campus", "Fortunestown", "Saggart", "Depot", "Broombridge", "Cabra",
             "Phibsborough", "Grangegorman", "Broadstone - DIT",
             "Dominick", "Parnell", "O'Connell - Upper", "O'Connell - GPO", "Marlborough", "Westmoreland", "Trinity",
             "Dawson", "St. Stephen's Green", "Harcourt",
             "Charlemont", "Ranelagh", "Beechwood", "Cowper", "Milltown", "Windy Arbour", "Dundrum", "Balally",
             "Kilmacud", "Stillorgan", "Sandyford",
             "Central Park", "Glencairn", "The Gallops", "Leopardstown Valley", "Ballyogan Wood", "Racecourse",
             "Carrickmines", "Brennanstown", "Laughanstown",
             "Cherrywood", "Brides Glen", "Blackhorse", "Bluebell", "Kylemore", "Red Cow", "Kingswood", "Belgard",
             "Cookstown", "Hospital", "Tallaght"];

luasStopsCode = ["TPT", "SDK", "MYS", "GDK", "CON", "BUS", "ABB", "JER", "FOU", "SMI", "MUS", "HEU", "JAM", "FAT",
                 "RIA", "SUI",
                 "GOL", "DRI", "FET", "CVN", "CIT", "FOR", "SAG", "DEP", "BRO", "CAB", "PHI", "GRA", "BRD", "DOM",
                 "PAR", "OUP", "OGP", "MAR", "WES", "TRY", "DAW",
                 "STS", "HAR", "CHA", "RAN", "BEE", "COW", "MIL", "WIN", "DUN", "BAL", "KIL", "STI", "SAN", "CPK",
                 "GLE", "GAL", "LEO", "BAW", "RCC", "CCK", "BRE",
                 "LAU", "CHE", "BRI", "BLA", "BLU", "KYL", "RED", "KIN", "BEL", "COO", "HOS", "TAL"]

# Read the timetables here
path_dir = os.path.dirname(__file__)
green_outbound_timetable = pd.read_csv(os.path.join(path_dir,
                                                    "../Server_DataTransformer/StaticFiles/luas_timetable/GreenLine-Sheet1-Broombridge-BridesGlen.csv"))
green_inbound_timetable = pd.read_csv(os.path.join(path_dir,
                                                   '../Server_DataTransformer/StaticFiles/luas_timetable/GreenLine-Sheet2-BridesGlen-Broombridge.csv'))
red_outbound_timetable = pd.read_csv(os.path.join(path_dir,
                                                  '../Server_DataTransformer/StaticFiles/luas_timetable/RedLine-Sheet2-ThePoint-Saggart.csv'))
red_inbound_timetable = pd.read_csv(os.path.join(path_dir,
                                                 '../Server_DataTransformer/StaticFiles/luas_timetable/RedLine-Sheet1-Saggart-ThePoint.csv'))

"""Luas Lines Data format:
line:{outbound:(source station, distination station,routes, timetable),
inbound:(source station, distination station,routes, timetable)}
"""
luas_lines_data = {
    "green": {
        "outbound": (
            ['BROOMBRIDGE', 'PARNELL', 'CENTRAL PARK'],
            ['BRIDE\'S GLEN', 'SANDYFORD'],
            {
                'BROOMBRIDGE-BRIDE\'S GLEN': (63),
                'BROOMBRIDGE-SANDYFORD': (49),
                'PARNELL-BRIDE\'S GLEN': (50),
                'PARNELL-SANDYFORD': (32),
                'CENTRAL PARK-BRIDGE GLEN': (18),
            },
            {
                "timetable": green_outbound_timetable,
            }
        ),
        "inbound": (
            ['SANDYFORD', 'BRIDE\'S GLEN', 'BROADSTONE_DIT'],
            ['BROOMBRIDGE', 'PARNELL', 'SANDYFORD'],
            {
                'BRIDE\'S GLEN-BROOMBRIDGE': (63),
                'BRIDE\'S GLEN-PARNELL': (53),
                'BRIDE\'S GLEN-SANDYFORD': (18),
                'BROADSTONE-DIT-BROOMBRIDGE': (7),
                'SANDYFORD-BROOMBRIDGE': (45),
                'SANDYFORD-PARNELL': (38)
            },
            {
                "timetable": green_inbound_timetable,
            }
        )
    },
    "red": {
        "outbound": (
            ['THE POINT', 'CONNOLLY', 'KINGSWOOD', 'BELGARD'],
            ['TALLAGHT', 'SAGGART', 'HEUSTON', 'RED COW'],
            {
                'THE POINT-TALLAGHT': (50),
                'CONNOLLY-SAGGART': (49),
                'KINGSWOOD-TALLAGHT': (7),
                'KINGSWOOD-SAGGART': (12),
                'BELGARD-SAGGART': (11),
                'THE POINT-SAGGART': (55),
                'CONNOLLY-TALLAGHT': (44),
                'CONNOLLY-HEUSTON': (14),
                'THE POINT-RED COW': (39),
                'CONNOLLY-RED COW': (33),
            },
            {
                "timetable": red_outbound_timetable,
            }
        ),
        "inbound": (
            ['RED COW', 'TALLAGHT', 'SAGGART', 'HEUSTON'],
            ['THE POINT', 'BELGARD', 'CONNOLLY', 'KINGSWOOD'],
            {
                'HEUSTON-CONNOLLY': (16),
                'RED COW-THE POINT': (38),
                'RED COW-CONNOLLY': (33),
                'SAGGART-BELGARD': (11),
                'SAGGART-CONNOLLY': (49),
                'SAGGART-THE POINT': (56),
                'SAGGART-KINGSWOOD': (12),
                'TALLAGHT-THE POINT': (50),
                'TALLAGHT-CONNOLLY': (47),
                'TALLAGHT-BELGARD': (6)
            },
            {
                "timetable": red_inbound_timetable,
            }
        )
    },
}


def getLuasData(request):
    start = time.time()
    luasData = {}
    green_line = {}
    red_line = {}
    for stop_code in luasStopsCode:
        print(f"[INFO] Gathering Data from Luas Station: {stop_code}")
        request_url = f"http://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop={stop_code}&encrypt=false"
        response = requests.get(request_url)
        root = ET.fromstring(response.text)
        luasStop = {}
        for x in root:
            if x.tag == "message":
                luasStop['line'] = x.text.split(" ")[0]
            else:
                direction = x.attrib['name']
                if direction == "Inbound":
                    inboundTrams = []
                    for y in x:
                        inboundTrams.append(y.attrib)
                    luasStop["inboundTrams"] = inboundTrams
                    luasStop["inboundTramsCount"] = len(inboundTrams)
                else:
                    outboundTrams = []
                    for y in x:
                        outboundTrams.append(y.attrib)
                    luasStop["outboundTrams"] = outboundTrams
                    luasStop["outboundTramsCount"] = len(outboundTrams)
        if luasStop['line'] == 'Red':
            red_line[stop_code] = luasStop
        else:
            green_line[stop_code] = luasStop
    luasData["green"] = green_line
    luasData["red"] = red_line
    end = time.time()
    print(f"[INFO] Time taken to gather Luas Data: {end - start}")
    green_line_elec, green_line_num_active_luas = estimate_electricity(luasData['green'], "green")
    red_line_elec, red_line_num_active_luas = estimate_electricity(luasData['red'], "red")
    result = {"luas_data": luasData,
              "green_line": {"electricity_consumption_estimate": green_line_elec,
                             "num_active_luas": green_line_num_active_luas},
              "red_line": {"electricity_consumption_estimate": red_line_elec,
                           "num_active_luas": red_line_num_active_luas}}
    return JsonResponse(result, safe=False)


def parse_time(time):
    # parsing the string to time format
    result = datetime.strptime(time, '%H:%M')
    parts = time.split(":")
    if (parts[0] == "00" or parts[0] == "01"):
        result += timedelta(days=1)
    return result


def find_tram_id(probable_start_time, duration, trams, destination, timetable):
    """find the tram that has the same tram id as the data passed and add to the dictionary of already active trams in the line"""
    for _, row in timetable.iterrows():
        start_time = row['start_time']
        diff = (parse_time(probable_start_time) - parse_time(start_time)).seconds
        diff = diff / 60
        if (diff >= -4 and diff <= 4) and destination == row['destination_station'].upper():
            new_tram = Tram(
                row['tram_id'],
                row['source_station'],
                row['destination_station'],
                duration
            )

            trams[row['tram_id']] = new_tram
            return True
    return False


def find_source_station(source_stations, routes, arrival_time, destination, trams, timetable):
    """Find the probable start time for the Luas in a given route"""
    for source in source_stations:
        route = source.upper() + "-" + destination
        if route not in routes:
            return "NOT FOUND"
        else:
            trip_time = routes[route]
            time_delta = timedelta(minutes=trip_time)
            probable_start_time = arrival_time - time_delta
            probable_start_time = probable_start_time.strftime('%H:%M')
            found_tram_id = find_tram_id(probable_start_time, time_delta, trams, destination, timetable)
            if found_tram_id:
                return source
    return "NOT FOUND"


def parse_trams(source_stations, routes, trams_list, trams, timetable):
    """For each Luas that we get from the real time data find the arrival time for it at the destination station"""
    current_time = datetime.now()
    for tram in trams_list:
        due_mins = tram['dueMins']
        due_mins = 0 if due_mins == "DUE" else due_mins
        try:
            due_mins = int(due_mins)
        except:
            continue
        arrival_time = current_time + timedelta(minutes=int(due_mins))
        destination = tram['destination'].upper()
        find_source_station(source_stations, routes, arrival_time, destination, trams, timetable)


def estimate_electricity(luas_stops, line):
    # estimate the electricity for each line
    trams = {}

    in_source_stations, _, in_routes, inbound_timetable = luas_lines_data[line]["inbound"]
    out_source_stations, _, out_routes, outbound_timetable = luas_lines_data[line]["outbound"]
    outbound_timetable = outbound_timetable["timetable"]
    inbound_timetable = inbound_timetable["timetable"]
    for _, values in luas_stops.items():
        inbound_trams = values["inboundTrams"]
        outbound_trams = values["outboundTrams"]
        parse_trams(in_source_stations, in_routes, inbound_trams, trams, inbound_timetable)
        parse_trams(out_source_stations, out_routes, outbound_trams, trams, outbound_timetable)

    # unique_trams = len(tram_ids)
    total_duration = 0

    for _, value in trams.items():
        total_duration += (value.duration.seconds) / 60

    result = total_duration * UNITS_PER_MIN
    return result, len(trams)
