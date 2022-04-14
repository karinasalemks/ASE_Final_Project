# test case for rest api responses

import unittest
import requests
from .. import Endpoints as apiSource


class TestViews(unittest.TestCase):
    def test_RESTConnection(self):
        response = requests.get(apiSource.DUBLIN_BIKES_API['source'])
        print(response)
        self.assertEqual(response.status_code, 200)
