from django.shortcuts import render
from . import APISelector
# Create your views here.
def getAPIEndpoint(target="DUBLIN_BIKES"):
    return APISelector.DynamicAPIGenerator.get(target)()