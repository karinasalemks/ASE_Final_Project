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

    # def test_APIresponse_Bus(self):
    #     response = requests.get(apiSource.DUBLIN_BUSES_API['PRIMARY'])
    #     self.assertEqual(response.status_code, 200)

    # def test_APIresponse_Events(self):
    #     url = ""
    #     response = requests.get(url)
    #     self.assertEqual(response.status_code, 201)


# if __name__ == '__main__':
#     unittest.main()
