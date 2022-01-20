from django.shortcuts import render
from django.http import HttpResponse
import requests,json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


# replace the key with the groups private key
cred_obj = credentials.Certificate('D:\Flutter\FirstProjectPK.json')
default_app = firebase_admin.initialize_app(cred_obj)
db =firestore.client()

def test():
    response = requests.get('https://data.smartdublin.ie/dublinbikes-api/last_snapshot/')
    print("***************After 5 minutes ****************")
    #print(response.content)
    posts_ref= db.collection(u'DublinbikeAvailability').document()
    posts_ref.set({
    'Response from API': str(response.content)
     })

    # for structure we can pass the time stamp and station id in document
    
    #return HttpResponse('Test Sucessful')
