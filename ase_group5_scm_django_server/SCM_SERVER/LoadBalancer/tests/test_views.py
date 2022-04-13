import unittest
import requests
import json


class TestViews(unittest.TestCase):

    # Alpha Server
    def alpha_availability(self):
        response = requests.get("https://scm-insights.herokuapp.com/availability/")
        print("alpha_availability", response.text)
        server_up = json.loads(response.text)['Server_up']
        return server_up

    def test_alpha_crash(self):
        requests.get("https://scm-insights.herokuapp.com/crash/")
        print("test_alpha_crash")
        status = self.alpha_availability()
        self.assertEqual(status, False)

    def test_alpha_reboot(self):
        requests.get("https://scm-insights.herokuapp.com/reboot/")
        print("test_alpha_reboot")
        status = self.alpha_availability()
        self.assertEqual(status, True)

    # Beta Server
    # def beta_availability(self):
    #     response = requests.get("https://scm-insights-beta.herokuapp.com/availability/")
    #     print("beta_availability", response.text)
    #     server_up = json.loads(response.text)['Server_up']
    #     return server_up
    #
    # def test_beta_crash(self):
    #     requests.get("https://scm-insights-beta.herokuapp.com/crash/")
    #     print("test_beta_crash")
    #     status = self.beta_availability()
    #     self.assertEqual(status, False)
    #
    # def test_beta_reboot(self):
    #     requests.get("https://scm-insights-beta.herokuapp.com/reboot/")
    #     print("test_beta_reboot")
    #     status = self.beta_availability()
    #     self.assertEqual(status, True)
    #
    # # Gamma Server
    # def gamma_availability(self):
    #     response = requests.get("https://scm-insights-gamma.herokuapp.com/availability/")
    #     print("gamma_availability", response.text)
    #     server_up = json.loads(response.text)['Server_up']
    #     return server_up
    #
    # def test_gamma_crash(self):
    #     requests.get("https://scm-insights-gamma.herokuapp.com/crash/")
    #     print("test_gamma_crash")
    #     status = self.gamma_availability()
    #     self.assertEqual(status, False)
    #
    # def test_gamma_reboot(self):
    #     requests.get("https://scm-insights-gamma.herokuapp.com/reboot/")
    #     print("test_gamma_reboot")
    #     status = self.gamma_availability()
    #     self.assertEqual(status, True)
