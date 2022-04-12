from django.test import TestCase

# Create your tests here.
import firebase_admin
from firebase_admin import credentials, firestore
import os
from django.http import JsonResponse

privateKeyPath = os.path.join(os.getcwd(), 'StaticFiles')
privateKeyPath = os.path.join(privateKeyPath, 'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

#default_app = firebase_admin.initialize_app(cred_obj)
default = firebase_admin.get_app(name='[DEFAULT]')
db = firestore.client()

