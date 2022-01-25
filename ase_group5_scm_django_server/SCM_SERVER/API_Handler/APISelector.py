from operator import truediv
from . import Endpoints
def selectBikesAPI():
    return selectValidAPISource(Endpoints.DUBLIN_BIKES_API)

def selectBusAPI():
    return selectValidAPISource(Endpoints.DUBLIN_BUSES_API)
    
def selectLuasAPI():
    return selectValidAPISource(Endpoints.DUBLIN_LUAS_API)

def selectEventsAPI():
    return selectValidAPISource(Endpoints.DUBLIN_EVENTS_API)


#TODO: Clarify what they mean by 'hard coded APIs calls should be avoided in the code'
def selectValidAPISource(endpoints):
    #TODO: Include the logic to dynamically select the API.
    from random import randint
    value = randint(1,100)
    if value % 2 == 0:
        return endpoints['PRIMARY'],True
    else:
        return endpoints['SECONDARY'],False

DynamicAPIGenerator = {
    "DUBLIN_BIKES": selectBikesAPI,
    "DUBLIN_BUS": selectBusAPI,
    "DUBLIN_LUAS": selectLuasAPI,
    "DUBLIN_EVENTS": selectEventsAPI,
}



