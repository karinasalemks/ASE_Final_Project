import unittest
from ..models import readSTOPSFile, BUS_STOP, readStopTimesFile
from ..Server_DataModel.busModel import STOPSEQUENCE, TRIP
from ..views import transformBUSData
# from ...ApiHandler import Endpoints as apiSource
import requests

path_to_stoptime = "/Users/deekshavyas/Documents/ASE/SustainableCity/ASE_Final_Project/ase_group5_scm_django_server/DataServer/Server_DataTransformer/StaticFiles/stop_times.csv"
path_to_stops = "/Users/deekshavyas/Documents/ASE/SustainableCity/ASE_Final_Project/ase_group5_scm_django_server/DataServer/Server_DataTransformer/StaticFiles/stops.csv"


class MyTestCase(unittest.TestCase):
    # For buses test case
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
        stop_time_update = [
            {'StopSequence': 1, 'StopId': '7010B158131', 'Departure': {'Delay': 16140},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 5, 'StopId': '8530B158221', 'Arrival': {'Delay': 16440}, 'Departure': {'Delay': 16560},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 6, 'StopId': '8530B1558401', 'Arrival': {'Delay': 16200}, 'Departure': {'Delay': 16200},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 7, 'StopId': '8530B1559601', 'Arrival': {'Delay': 16140}, 'Departure': {'Delay': 16140},
             'ScheduleRelationship': 'Scheduled'},
            {'StopSequence': 17, 'StopId': '8510B5550801', 'Arrival': {'Delay': 16740}, 'Departure': {'Delay': 16200},
             'ScheduleRelationship': 'Scheduled'}]
        result_list = STOPSEQUENCE.getStopSequenceList(stop_time_update, '10-64-e19-1', 'I')
        stop_obj = result_list[0]
        self.assertEqual(isinstance(result_list, list), True)
        self.assertEqual(any(isinstance(x, STOPSEQUENCE) for x in result_list), True)
        self.assertEqual(isinstance(stop_obj.stop_sequence_id, int), True)
        self.assertEqual(isinstance(stop_obj.bus_stop, BUS_STOP), True)
        self.assertEqual(isinstance(stop_obj.arrival_time, str), True)
        self.assertEqual(isinstance(stop_obj.departure_time, str), True)

if __name__ == '__main__':
    unittest.main()
