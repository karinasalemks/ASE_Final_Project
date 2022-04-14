# test case for checking bike, bus and events responses

import unittest
import requests
from .. import Endpoints as apiSource
from ApiHandler.views import getLuasData, aggregateWeatherForecast
import json


class MyTestCase(unittest.TestCase):
    def test_APIresponse_Bike(self):
        response = requests.get(apiSource.DUBLIN_BIKES_API['PRIMARY'])
        response2 = requests.get(apiSource.DUBLIN_BIKES_API['SECONDARY'])
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response2.status_code, 200)

    def test_APIresponse_Bus(self):
        headers = apiSource.DUBLIN_BUS_HEADER
        response = requests.get(apiSource.DUBLIN_BUSES_API['PRIMARY'], headers=headers)
        self.assertEqual(response.status_code, 200)

    # def test_APIresponse_Events(self):
    #     response = requests.get(apiSource.DUBLIN_EVENTS_API['PRIMARY'])
    #     self.assertEqual(response.status_code, 200)

    def test_LUAS_API_data_transform(self):
        respons = getLuasData("")
        response = json.loads(respons.content)
        # print("response", response)
        # print("ku", response["luas_data"])
        self.assertEqual(isinstance(response['luas_data'], dict), True)
        self.assertEqual(isinstance(response['red_line'], dict), True)
        self.assertEqual(isinstance(response['green_line'], dict), True)
        self.assertEqual(any(isinstance(x, int) for x in response['green_line'].values()), True)
        self.assertEqual(any(isinstance(x, int) for x in response['red_line'].values()), True)
        for value in response['luas_data'].values():
            self.assertEqual(isinstance(value["line"], str), True)
            self.assertEqual(isinstance(value["inboundTrams"], list), True)
            self.assertEqual(isinstance(value["inboundTramsCount"], int), True)
            self.assertEqual(isinstance(value["outboundTrams"], list), True)
            self.assertEqual(isinstance(value["outboundTramsCount"], int), True)
            self.assertEqual(any(isinstance(x, dict) for x in value['outboundTrams']), True)
            self.assertEqual(any(isinstance(x, dict) for x in value['inboundTrams']), True)
            self.assertEqual(any(isinstance(y, str) for y in (i["destination"] for i in value['inboundTrams'])), True)
            self.assertEqual(any(isinstance(y, str) for y in (i["dueMins"] for i in value['inboundTrams'])), True)
            self.assertEqual(any(isinstance(y, str) for y in (i["destination"] for i in value['outboundTrams'])), True)
            self.assertEqual(any(isinstance(y, str) for y in (i["dueMins"] for i in value['outboundTrams'])), True)

    def test_WEATHER_API_data_transform(self):
        respons = aggregateWeatherForecast("")
        response = json.loads(respons.content)
        # self.assertEqual(any(isinstance(x, dict) for x in response['green_line'].values()), True)
        self.assertEqual(isinstance(response, dict), True)
        self.assertEqual(any(isinstance(x, dict) for x in response.values()), True)
        for value in response.values():
            # print("value", value)
            self.assertEqual(isinstance(value['min_temp'], float), True)
            self.assertEqual(isinstance(value['max_temp'], float), True)
            self.assertEqual(isinstance(value['wind_speed'], float), True)
            self.assertEqual(isinstance(value['cloudiness'], float), True)
            self.assertEqual(isinstance(value['rain_prob'], float), True)
            self.assertEqual(isinstance(value['rainfall'], float), True)
            if 'warning' in value:
                self.assertEqual(isinstance(value['warning'], dict), True)
                for v in value['warning'].values():
                    self.assertEqual(isinstance(v, str), True)
