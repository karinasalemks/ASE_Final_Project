from ..views import transformBikeData
import json
import unittest
from Server_DataTransformer.Server_DataModel.busModel import readSTOPSFile, BUS_STOP, readStopTimesFile, STOPSEQUENCE, \
    TRIP
from Server_DataTransformer.views import transformBUSData, transformEventsData

path_to_stoptime = "Server_DataTransformer/StaticFiles/stop_times.csv"
path_to_stops = "Server_DataTransformer/StaticFiles/stops.csv"


class TestViews(unittest.TestCase):

    def test_transform_bike_data_primary(self):
        isPrimarySource = True

        response = [
            {"id": 46085583, "harvest_time": "2022-02-03T16:35:02", "station_id": 2, "available_bike_stands": 11,
             "bike_stands": 20, "available_bikes": 9, "banking": False, "bonus": False,
             "last_update": "2022-02-03T16:25:46", "status": "OPEN", "address": "Blessington Street",
             "name": "BLESSINGTON STREET", "latitude": "53.3568", "longitude": "-6.26814"}]

        # checks that the data types returned are the correct format
        result = json.loads(transformBikeData(response, isPrimarySource)[0])
        # self.assertEqual(isinstance(result, BikeModel), True)
        self.assertEqual(isinstance(result['harvest_time'], str), True)
        self.assertEqual(isinstance(result['station_id'], str), True)
        self.assertEqual(isinstance(result['latitude'], str), True)
        self.assertEqual(isinstance(result['longitude'], str), True)
        self.assertEqual(isinstance(result['station_name'], str), True)
        self.assertEqual(isinstance(result['station_status'], str), True)
        self.assertEqual(isinstance(result['available_bike_stands'], int), True)
        self.assertEqual(isinstance(result['bike_stands'], int), True)
        self.assertEqual(isinstance(result['available_bikes'], int), True)
        self.assertEqual(result['available_bike_stands'] < 0, False)
        self.assertEqual(result['bike_stands'] < 0, False)

    def test_transform_bike_data_not_primary(self):
        isPrimarySource = False

        response = [
            {"number": 42, "contract_name": "dublin", "name": "SMITHFIELD NORTH", "address": "Smithfield North",
             "position": {
                 "lat": 53.349562,
                 "lng": -6.278198},
             "banking": False, "bonus": False, "bike_stands": 30, "available_bike_stands": 15, "available_bikes": 15,
             "status": "OPEN", "last_update": 1643966701000}]

        # checks that the data types returned are the correct format
        result = json.loads(transformBikeData(response, isPrimarySource)[0])
        self.assertEqual(isinstance(result['harvest_time'], str), True)
        self.assertEqual(isinstance(result['station_id'], str), True)
        self.assertEqual(isinstance(result['latitude'], str), True)
        self.assertEqual(isinstance(result['longitude'], str), True)
        self.assertEqual(isinstance(result['station_name'], str), True)
        self.assertEqual(isinstance(result['station_status'], str), True)
        self.assertEqual(isinstance(result['available_bike_stands'], int), True)
        self.assertEqual(isinstance(result['bike_stands'], int), True)
        self.assertEqual(isinstance(result['available_bikes'], int), True)
        self.assertEqual(result['available_bikes'] < 0 , False)
        self.assertEqual(result['available_bike_stands'] < 0, False)
        self.assertEqual(result['bike_stands'] < 0, False)

    def test_read_stop_times_file(self):
        stop_times_dict_result = readStopTimesFile(path_to_stoptime)
        self.assertEqual(isinstance(stop_times_dict_result, dict), True)
        self.assertEqual(any(isinstance(x, tuple) for x in stop_times_dict_result.keys()), True)
        self.assertEqual(any(isinstance(x, list) for x in stop_times_dict_result.values()), True)

    def test_read_stops_file(self):
        stops_dict_result = readSTOPSFile(path_to_stops)
        self.assertEqual(isinstance(stops_dict_result, dict), True)
        self.assertEqual(any(isinstance(x, str) for x in stops_dict_result.keys()), True)
        self.assertEqual(any(isinstance(x, BUS_STOP) for x in stops_dict_result.values()), True)
        self.assertEqual(any(isinstance(x, str) for x in (d for d in stops_dict_result.keys())), True)
        if (len(stops_dict_result) > 0):
            key = next(iter(stops_dict_result))
            value = stops_dict_result[key]
            self.assertEqual(isinstance(value.stop_id, str), True)
            self.assertEqual(isinstance(value.name, str), True)
            self.assertEqual(isinstance(value.latitude, float), True)
            self.assertEqual(isinstance(value.longitude, float), True)

    def test_get_sequence_list(self):
        print("*************try")

        stop_time_update = [
            {'StopSequence': 14, 'StopId': '8240DB010381', 'Departure': {'Delay': 16140},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 15, 'StopId': '8240DB003884', 'Arrival': {'Delay': 16440}, 'Departure': {'Delay': 16560},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 16, 'StopId': '8240DB003686', 'Arrival': {'Delay': 16200}, 'Departure': {'Delay': 16200},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 7, 'StopId': '8530B1559601', 'Arrival': {'Delay': 16140}, 'Departure': {'Delay': 16140},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 17, 'StopId': '8240DB005077', 'Arrival': {'Delay': 16740}, 'Departure': {'Delay': 16200},
             'ScheduleRelationship': 'Scheduled'}]

        result_list = STOPSEQUENCE.getStopSequenceList(stop_time_update, '10-64-e19-1', 'I')
        if (len(result_list) > 0):
            self.assertEqual(isinstance(result_list, list), True)
            self.assertEqual(any(isinstance(x, str) for x in result_list), True)
            print("*************try***END")

    def test_get_bus_trips(self):
        isPrimarySource = True
        response = {"Entity": [
            {
                "Id": "3692367.40.10-64-e19-1.152.O",
                "IsDeleted": False,
                "TripUpdate": {
                    "Trip": {
                        "TripId": "3692367.40.10-64-e19-1.152.O",
                        "RouteId": "10-64-e19-1",
                        "StartTime": "11:10:00",
                        "StartDate": "20220217",
                        "ScheduleRelationship": "Scheduled"
                    },
                    "StopTimeUpdate": [
                        {
                            "StopSequence": 1,
                            "StopId": "7010B158131",
                            "Departure": {
                                "Delay": 16140
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 3,
                            "StopId": "8530B158191",
                            "Arrival": {
                                "Delay": 16680
                            },
                            "Departure": {
                                "Delay": 16680
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 4,
                            "StopId": "8530B158201",
                            "Arrival": {
                                "Delay": 16560
                            },
                            "Departure": {
                                "Delay": 16560
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 5,
                            "StopId": "8530B158221",
                            "Arrival": {
                                "Delay": 16440
                            },
                            "Departure": {
                                "Delay": 16560
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 6,
                            "StopId": "8530B1558401",
                            "Arrival": {
                                "Delay": 16200
                            },
                            "Departure": {
                                "Delay": 16200
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 7,
                            "StopId": "8530B1559601",
                            "Arrival": {
                                "Delay": 16140
                            },
                            "Departure": {
                                "Delay": 16140
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 8,
                            "StopId": "8530B141301",
                            "Arrival": {
                                "Delay": 16740
                            },
                            "Departure": {
                                "Delay": 16740
                            },
                            "ScheduleRelationship": "Scheduled"
                        },
                        {
                            "StopSequence": 17,
                            "StopId": "8510B5550801",
                            "Arrival": {
                                "Delay": 16740
                            },
                            "Departure": {
                                "Delay": 16200
                            },
                            "ScheduleRelationship": "Scheduled"
                        }
                    ]
                }
            }]}

        trips_result = transformBUSData(response, isPrimarySource)
        self.assertEqual(isinstance(trips_result['trips_list'], list), True)
        self.assertEqual(isinstance(trips_result['part_of_trips'], dict), True)

    def test_transform_events_data_primary(self):
        isPrimarySource = True
        response = open('Server_DataTransformer/tests/eventsResponse.json', 'r')
        x = json.load(response)
        result = json.loads(transformEventsData(x, isPrimarySource)[0])
        self.assertEqual(isinstance(result['events'], dict), True)
        self.assertEqual(isinstance(result['latitude'], str), True)
        self.assertEqual(isinstance(result['longitude'], str), True)
        self.assertEqual(isinstance(result['nearest_bus_stops'], dict), True)
        self.assertEqual(isinstance(result['location_name'], str), True)


