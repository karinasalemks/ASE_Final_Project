from django.shortcuts import render
from . import Endpoints
from django.http import JsonResponse
from DataTransformer.views import transformData
from django.http import HttpResponse
import requests, json

def getBikeData(request):
    endpoint = None
    isPrimarySource = None
    from random import randint
    value = randint(1, 100)
    if value % 2 == 0:
        endpoint = Endpoints.DUBLIN_BIKES_API['PRIMARY']
        isPrimarySource = True
    else:
        endpoint = Endpoints.DUBLIN_BIKES_API['SECONDARY']
        isPrimarySource = False

    response = requests.get(endpoint)
    dublinBikesData = transformData(apiResponse=response,isPrimarySource=isPrimarySource)
    return JsonResponse({"foo":"Bar"})
