# test case for rest api responses

import unittest
import requests
from static import Endpoints as apiSource
import errno

class TestViews(unittest.TestCase):

    # hostName = "https://scm-insights.herokuapp.com"
   # https://scm-insights-Alpha.herokuapp.com
    hostName = "http://127.0.0.1:7000"
    def test_data_servers_availability(self):
        print("*************checking Alpha data server availability*******")
        try:
            response = requests.get("http://127.0.0.1:7000/availability/")
            self.assertEqual(response.text, "{\"status\": 200}")
            print("*************Alpha server is available********************")

            print("*************checking Beta data server availability*******")
            response = requests.get("http://127.0.0.1:7001/availability/")
            self.assertEqual(response.text, "{\"status\": 200}")
            print("*************Beta server is available********************")

            print("*************checking Gamma data server availability*******")
            response = requests.get("http://127.0.0.1:7002/availability/")
            self.assertEqual(response.text, "{\"status\": 200}")
            print("*************Gamma server is available********************")
        except IOError as e :
            print("404 not found")
        else :
            print("AssertionError found")

    def test_all_dataserver_connection(self):
        print("*************testing all the data server point connections*****************")
        response = requests.get(hostName+ apiSource.DUBLIN_BIKES_API['source'])
        print("*************checking DUBLIN BIKES source data point connection************")
        self.assertEqual(response.status_code, 200)
        print("*************DUBLIN BIKES source end point is active************")
        response = requests.get(hostName+apiSource.DUBLIN_BUSES_API['source'])
        print("*************checking DUBLIN BUS source data point connection**************")
        self.assertEqual(response.status_code, 200)
        print("*************DUBLIN Bus source end point is active************")
        response = requests.get(hostName+apiSource.DUBLIN_BUSES_API['busStops'])
        print("*************checking Bus stops data connection**************")
        self.assertEqual(response.status_code, 200)
        print("*************Bus stops data connection is active************")
        response = requests.get(hostName+apiSource.DUBLIN_LUAS_API['source'])
        print("*************checking Luas source data connection************")
        self.assertEqual(response.status_code, 200)
        print("************* Luas source data connection is active ************")
        response = requests.get(hostName+apiSource.DUBLIN_LUAS_API['stops'])
        print("*************checking Luas stops data connection*************")
        self.assertEqual(response.status_code, 200)
        print("*************Luas stops data connection is active*************")

if __name__ == '__main__':
    unittest.main()