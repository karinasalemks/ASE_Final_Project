import firebase_admin
from firebase_admin import credentials, firestore
import os

# replace the key with the groups private key
privateKeyPath = os.path.join(os.getcwd(), 'static')
privateKeyPath = os.path.join(privateKeyPath, 'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()
