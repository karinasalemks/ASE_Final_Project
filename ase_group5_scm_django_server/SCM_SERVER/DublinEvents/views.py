from django.shortcuts import render
import requests, json
from . import Endpoints as apiSource
import json
import time
from static.firebaseInitialization import db
from django.http import JsonResponse

from DataTransformer.views import transformData

def eventsDataCreate(request):
    start = time.time()
    print("*************** Fetching Dublin Events API ****************")
    response = requests.get(apiSource.DUBLIN_EVENTS_API['source'])
    if response.status_code == 200 or response.status_code == 201:
        eventsData = json.loads(response.text)
        eventsCollectionRef = db.collection(u'DublinEvents')
        batch = db.batch()
        for location in eventsData:
            jsonEvent = json.loads(location[0]);
            currentDocRef = eventsCollectionRef.document(jsonEvent['location_name'])
            doc = currentDocRef.get()
            if doc.exists:
                batch.update(currentDocRef, jsonEvent)
            else:
                batch.set(currentDocRef, jsonEvent)
        batch.commit()
        print("Batch Transaction Complete..")
    else:
        print("Response code:-", response.status_code)
    end = time.time()
    print(end - start)
    return JsonResponse({"status":"Hurray!"})
    
