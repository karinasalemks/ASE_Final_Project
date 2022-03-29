from static import Endpoints as apiSource
import requests, json
from static.firebaseInitialization import db

# Create your views here.
def busTripsToFirebase():
    print("*************** Fetching Dublin Weather API ****************")
    weatherResponse = requests.get(apiSource.DUBLIN_EVENTS_API['weatherForecast'])
    print("*************** Fetching Done ****************")
    if weatherResponse.status_code == 200 or weatherResponse.status_code == 201:
        weatherData = json.loads(weatherResponse.text)

        #Update weather
        data = {'data':weatherData}
        db.collection(u'DublinWeather').document(u'forecast').set(data)

    else:
        print("Response code:-", weatherResponse.status_code)

