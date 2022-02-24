
from diagrams import Diagram, Cluster,Edge

from diagrams.programming.framework import Django
from diagrams.programming.framework import Flutter
from diagrams.firebase.develop import RealtimeDatabase
from diagrams.onprem.database import PostgreSQL,Mysql
from diagrams.programming.flowchart import SummingJunction,Preparation
from diagrams.oci.database import DatabaseService
from diagrams.gcp.api import Endpoints
from diagrams.gcp.database import SQL

from diagrams.custom import Custom

with Diagram("Technical Architecture", direction='RL') as diag: # It's LR by default, but you have a few options with the orientation
    
    with Cluster("Frontend"):
        flutter = Flutter("User Interface")
        

    firebase = RealtimeDatabase("Firebase")

    with Cluster("External Data Sources"):
        dataSourcesGroup = [
            SQL("Luas"),
            SQL("Bikes"),
            SQL("Buses"),
            SQL("Events/Incidents"),
        ]
        
    with Cluster(""):
        dataTransformer = DatabaseService("Data Transformer")
        django = Django("Server")
        apiEngine = Endpoints("Live\nData Handler")

        with Cluster("Prediction Engine"):
            predictionGroup = [
                Custom("",'scikitLearn.png'),
                Custom("",'s.png')
            ]
        apiEngine >> predictionGroup >> dataTransformer >> firebase >> flutter

        
    dataSourcesGroup >> apiEngine

    #TODO:Ad legend for every tech stack
    #PostgreSQL("PostgreSQL"),
diag  
