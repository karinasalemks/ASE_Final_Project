import requests
import json
from EVENTS_MODEL import EVENTS
import datetime
from datetime import timedelta

#Mapping to get the event Id for event location
def get_url_link(i):
    """returns the event id for respective event place"""
    switcher={
            "Aviva":"KovZ9177Tn7",
            "3Arena":"KovZ9177WYV",
            "RDS":"KovZ9177TAf",
            "National Stadium":"KovZ9177TZf",
            "Bord Gais Energy Theatre":"KovZ917AZa7",
            "Gaiety Theatre":"KovZ9177XT0"
            }
    return switcher.get(i,"Invalid event location")

def getResponseData(place):
    """returns the api response based on the event place"""
    #get the current datetime and convert it to a format required for API request
    today = datetime.datetime.now()
    today_time = today.strftime("%H:%M:%S")
    today_date = today.strftime("%Y-%m-%d")
    formated_date_time = today_date+'T'+today_time+'Z'
    #get the datetime after 30 days and convert it to a format required for API request
    month_later = datetime.datetime.now() + timedelta(days=30)
    month_later_time = month_later.strftime("%H:%M:%S")
    month_later_date = month_later.strftime("%Y-%m-%d")
    month_later_formated_date_time = month_later_date + 'T' + month_later_time + 'Z'
    
    #Create request url with event id,start date & end date(current + 30 days)
    url = "https://app.ticketmaster.com/discovery/v2/events.json?venueId="+ get_url_link(place) + "&startDateTime=" + formated_date_time+ "&endDateTime=" + month_later_formated_date_time +  "&apikey=Od2QOTqrUGW7CPeiRXSgzGv3zGAquRAL"
    
    response = requests.get(url)
    if (response.status_code == 200):
        api_response = response.json()
        try:
            events = api_response["_embedded"]["events"]
            return events
        except KeyError:
            print("Error, no key field", KeyError)
            return ''
    else:
        print(response.status_code)
        return ''
        
def getEventsData():
    """returns a list of EVENTS objects"""
    popular_events = ["Aviva", "3Arena", "RDS", "National Stadium", "Bord Gais Energy Theatre", "Gaiety Theatre"]
    #list that contains all the details of the event happenings
    events_list = []
    #For every event location get the api response and create the event details
    for place in popular_events:
        api_response = getResponseData(place)
        try:
            #For each event in the reponse data, read and get the event details to for EVENTS objects
            for event in api_response:
                event_name = event["name"]
                event_date_time = event["dates"]["start"]["dateTime"]
                event_location_name = event["_embedded"]["venues"][0]["name"]
                event_location_longitude = event["_embedded"]["venues"][0]["location"]["longitude"]
                event_location_latitude = event["_embedded"]["venues"][0]["location"]["latitude"]
                event_data = EVENTS(event_name, event_date_time, event_location_name, event_location_longitude, event_location_latitude)
                events_list.append(event_data)
        except KeyError:
            print("Error, no key field", KeyError)
    return events_list
                    
getEventsData()
