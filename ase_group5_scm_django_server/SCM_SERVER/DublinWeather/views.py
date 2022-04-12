from static import Endpoints as apiSource
import requests, json
from static.firebaseInitialization import db
from LoadBalancer.views import send_request

def weatherToFirebase():
    print("*************** Fetching Dublin Weather API ****************")
    weatherResponse = send_request(apiSource.DUBLIN_EVENTS_API['weatherForecast'])
    print("*************** Fetching Done ****************")
    if weatherResponse.status_code == 200 or weatherResponse.status_code == 201:
        weatherData = json.loads(weatherResponse.text)

        batch = db.batch()
        #Update weather
        data = {'data':weatherData}
        dublin_weather_collection = db.collection(u'DublinWeather')
        weather_forecast_document = dublin_weather_collection.document("forecast")
        doc = weather_forecast_document.get()
        if doc.exists:
            batch.update(weather_forecast_document, data)
        else:
            batch.set(weather_forecast_document, data)

        batch.commit()
        print("Weather Batch Transaction Complete..")
    else:
        print("Response code:-", weatherResponse.status_code)

