from DataTransformer.views import transformBikeData
import unittest
from DataTransformer.DataModel.bikeModel import BikeModel


class TestViews(unittest.TestCase):
    def test_transform_bike_data_primary(self):
        isPrimarySource = True

        response = [
            {"id": 46085583, "harvest_time": "2022-02-03T16:35:02", "station_id": 2, "available_bike_stands": 11,
             "bike_stands": 20, "available_bikes": 9, "banking": False, "bonus": False,
             "last_update": "2022-02-03T16:25:46", "status": "OPEN", "address": "Blessington Street",
             "name": "BLESSINGTON STREET", "latitude": "53.3568", "longitude": "-6.26814"}]

        # checks that the data types returned are the correct format
        result = transformBikeData(response, isPrimarySource)[0]
        self.assertEqual(isinstance(result, BikeModel), True)
        self.assertEqual(isinstance(result.harvest_time, str), True)
        self.assertEqual(isinstance(result.station_id, str), True)
        self.assertEqual(isinstance(result.latitude, str), True)
        self.assertEqual(isinstance(result.longitude, str), True)
        self.assertEqual(isinstance(result.station_name, str), True)
        self.assertEqual(isinstance(result.station_status, str), True)
        self.assertEqual(isinstance(result.available_bikeStands, int), True)
        self.assertEqual(isinstance(result.bike_stands, int), True)
        self.assertEqual(isinstance(result.available_bikes, list), True)
        self.assertEqual(isinstance(result.occupancy_list, list), True)
        self.assertEqual(len(result.available_bikes), 289)
        self.assertEqual(len(result.occupancy_list), 289)
        self.assertEqual(any(x < 0 for x in result.available_bikes), False)
        self.assertEqual(any(x < 0 for x in result.occupancy_list), False)
        self.assertEqual(result.available_bikeStands < 0, False)
        self.assertEqual(result.bike_stands < 0, False)

    def test_transform_bike_data_not_primary(self):
        isPrimarySource = False


        response = [
            {"number": 42, "contract_name": "dublin", "name": "SMITHFIELD NORTH", "address": "Smithfield North", "position": {
                "lat": 53.349562,
                "lng": -6.278198},
             "banking": False, "bonus": False, "bike_stands": 30, "available_bike_stands": 15, "available_bikes": 15,
             "status": "OPEN", "last_update": 1643966701000}]

        # checks that the data types returned are the correct format
        result = transformBikeData(response, isPrimarySource)[0]
        self.assertEqual(isinstance(result, BikeModel), True)
        self.assertEqual(isinstance(result.harvest_time, str), True)
        self.assertEqual(isinstance(result.station_id, str), True)
        self.assertEqual(isinstance(result.latitude, str), True)
        self.assertEqual(isinstance(result.longitude, str), True)
        self.assertEqual(isinstance(result.station_name, str), True)
        self.assertEqual(isinstance(result.station_status, str), True)
        self.assertEqual(isinstance(result.available_bikeStands, int), True)
        self.assertEqual(isinstance(result.bike_stands, int), True)
        self.assertEqual(isinstance(result.available_bikes, list), True)
        self.assertEqual(isinstance(result.occupancy_list, list), True)
        self.assertEqual(len(result.available_bikes), 289)
        self.assertEqual(len(result.occupancy_list), 289)
        self.assertEqual(any(x < 0 for x in result.available_bikes), False)
        self.assertEqual(any(x < 0 for x in result.occupancy_list), False)
        self.assertEqual(result.available_bikeStands < 0, False)
        self.assertEqual(result.bike_stands < 0, False)
