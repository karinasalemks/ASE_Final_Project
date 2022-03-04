# test case for checking bike, bus and events responses

import unittest
import requests
from .. import Endpoints as apiSource


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

    def test_APIresponse_Events(self):
        response = requests.get(apiSource.DUBLIN_EVENTS_API['PRIMARY'])
        self.assertEqual(response.status_code, 200)

# if __name__ == '__main__':
#     unittest.main()
