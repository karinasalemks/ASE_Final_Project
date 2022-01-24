from . import Endpoints
def selectBikesAPI():
    return selectValidAPISource(Endpoints.DUBLIN_BIKES_API)

def selectBusAPI():
    return selectValidAPISource(Endpoints.DUBLIN_BUSES_API)
    
def selectLuasAPI():
    return selectValidAPISource(Endpoints.DUBLIN_LUAS_API)

def selectEventsAPI():
    return selectValidAPISource(Endpoints.DUBLIN_EVENTS_API)

def selectValidAPISource(endpoints):
    #TODO: Include the logic to dynamically select the API.
    return endpoints['PRIMARY']

DynamicAPIGenerator = {
    "DUBLIN_BIKES": selectBikesAPI,
    "DUBLIN_BUS": selectBusAPI,
    "DUBLIN_LUAS": selectLuasAPI,
    "DUBLIN_EVENTS": selectEventsAPI,
}



