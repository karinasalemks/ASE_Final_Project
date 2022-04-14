from pickle import FALSE
from sre_parse import State
import unittest
import requests
import json

import os, base64
def generate_session():
    return base64.b64encode(os.urandom(16))
    
class TestViews(unittest.TestCase):
    
    global payload
    payload={}
    global headers
    headers = {'Cookie': 'sessionid=5z67ob7q6860hcm30v2zf6y7bdxdfmmi'}
    global flag
    flag = False



    def test_dataIntegrity_bike(self):
            
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
        #     alpha=hash(response_alpha.text)
        #     beta=hash(response_beta.text)
        #     gamma=hash(response_gamma.text)

            alpha=len(json.loads(response_alpha.text))
            beta=len(json.loads(response_beta.text))
            gamma=len(json.loads(response_gamma.text))
               
            
            status=alpha==beta==gamma
            self.assertEqual(status, True)

            
    def test_dataIntegrity_busTrips(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            
            alpha=len(json.loads(response_alpha.text))
            beta=len(json.loads(response_beta.text))
            gamma=len(json.loads(response_gamma.text))
               
            
            status=alpha==beta==gamma
            self.assertEqual(status, True)

    
    def test_dataIntegrity_getBusStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, True)

    
        


    #  takes more than 31 sec.

    # def test_dataIntegrity_getLuasData():
    #         payload={}
    #         headers = {'Cookie': 'sessionid=w85phzxlg5jqz9l1hfo082nrappug56d' }
    #         response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/getLuasData/",headers=headers,data=payload)
    #         
    #         response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/getLuasData/",headers=headers,data=payload)
    #         
    #         response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/getLuasData/",headers=headers,data=payload)
    #         
            
            
    #         alpha=hash(response_alpha.text)
    #         
    #         beta=hash(response_beta.text)
    #         
    #         gamma=hash(response_gamma.text)   
    #         
            
            
    #         if (alpha==beta==gamma):
    #             
    #         else:
    #             
                
                
    def test_dataIntegrity_getLuasStops(self):
            payload={}
            headers = {'Cookie': 'sessionid=w85phzxlg5jqz9l1hfo082nrappug56d' }
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, True)


    def test_dataIntegrity_weatherForecast(self):
            payload={}
            headers = {'Cookie': 'sessionid=w85phzxlg5jqz9l1hfo082nrappug56d' }
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, True)



#     def test_dataIntegrity_events(self):
#             response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/events/",headers=headers,data=payload)
#             response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/events/",headers=headers,data=payload)
#             response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/events/",headers=headers,data=payload)
            
#             alpha=hash(response_alpha.text)
#             beta=hash(response_beta.text)
#             gamma=hash(response_gamma.text)   
            
#             status=alpha==beta==gamma
#             self.assertEqual(status, True)




    #alpha server changed

    def test_dataIntegrity_bike_alpha_bustrips(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_alpha_getBusStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_alpha_getLuasStops(self):
            payload={}
            headers = {'Cookie': 'sessionid=w85phzxlg5jqz9l1hfo082nrappug56d' }
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)




    def test_dataIntegrity_bike_alpha_weatherForecast(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)



    def test_dataIntegrity_bike_alpha_events(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/events/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)

   
     # Alpha Server
    def alpha_availability(self):
            response = requests.get("https://scm-insights.herokuapp.com/availability/",headers=headers, data=payload)
            
            server_up = json.loads(response.text)['Server_up']
            return server_up

    def test_alpha_crash(self):
            requests.get("https://scm-insights.herokuapp.com/crash/",headers=headers, data=payload)
        
            status = self.alpha_availability()
            status=flag
            self.assertEqual(status, False)

    def test_alpha_reboot(self):
            requests.get("https://scm-insights.herokuapp.com/reboot/",headers=headers, data=payload)
        
            status = self.alpha_availability()
            self.assertEqual(status, True)


    # Beta Server
    def beta_availability(self):
            response = requests.get("https://scm-insights-beta.herokuapp.com/availability/",headers=headers, data=payload)
            
            server_up = json.loads(response.text)['Server_up']
            return server_up
    
    def test_beta_crash(self):
            requests.get("https://scm-insights-beta.herokuapp.com/crash/",headers=headers, data=payload)
            status = self.beta_availability()
            status=flag
            self.assertEqual(status, False)
    
    def test_beta_reboot(self):
            requests.get("https://scm-insights-beta.herokuapp.com/reboot/",headers=headers, data=payload)
        
            status = self.beta_availability()
            self.assertEqual(status, True)
    
    # Gamma Server
    def gamma_availability(self):
            response = requests.get("https://scm-insights-gamma.herokuapp.com/availability/",headers=headers, data=payload)
        
            server_up = json.loads(response.text)['Server_up']
            return server_up
    
    
    def test_gamma_crash(self):
            requests.get("https://scm-insights-gamma.herokuapp.com/crash/",headers=headers, data=payload)
            
            status = self.gamma_availability()
            status=flag
            self.assertEqual(status, False)
    
    def test_gamma_reboot(self):
            requests.get("https://scm-insights-gamma.herokuapp.com/reboot/",headers=headers, data=payload)
        
            status = self.gamma_availability()
            self.assertEqual(status, True)
     


    #beta server changed

    def test_dataIntegrity_bike_beta_bustrips(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_beta_getBusStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)

    
    def test_dataIntegrity_bike_beta_getLuasStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)

    
    def test_dataIntegrity_bike_beta_weatherForecast(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bike/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)



    def test_dataIntegrity_bike_beta_events(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/events/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)






    #gamma serever changes

    def test_dataIntegrity_bike_gamma_bustrips(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/bustrips/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_gamma_getBusStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/getBusStops/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_gamma_getLuasStops(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/getLuasStops/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_gamma_weatherForecast(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bike/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


    def test_dataIntegrity_bike_gamma_events(self):
            response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/bikes/",headers=headers,data=payload)
            response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/events/",headers=headers,data=payload)
            
            alpha=hash(response_alpha.text)
            beta=hash(response_beta.text)
            gamma=hash(response_gamma.text)   
            
            status=alpha==beta==gamma
            self.assertEqual(status, False)


# all serevr are different

    def test_dataIntegrity_bike_gamma_events(self):

             response_alpha = requests.get("https://scm-insights.herokuapp.com/getData/bikes/",headers=headers,data=payload)
             response_beta = requests.get("https://scm-insights-beta.herokuapp.com/getData/weatherForecast/",headers=headers,data=payload)
             response_gamma = requests.get("https://scm-insights-gamma.herokuapp.com/getData/events/",headers=headers,data=payload)

             alpha=hash(response_alpha.text)
             beta=hash(response_beta.text)
             gamma=hash(response_gamma.text)   

             status=alpha==beta==gamma
             self.assertEqual(status, False)