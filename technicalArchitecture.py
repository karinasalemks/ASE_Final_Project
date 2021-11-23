
from diagrams import Diagram, Cluster

from diagrams.programming.framework import Django
from diagrams.programming.framework import Flutter
from diagrams.firebase.develop import RealtimeDatabase
from diagrams.onprem.database import PostgreSQL,Mysql

from diagrams.custom import Custom

with Diagram("Technical Architecture", direction='RL') as diag: # It's LR by default, but you have a few options with the orientation
    
    with Cluster("Frontend"):
        flutter = Flutter("User Interface")
        with Cluster("Local Database"):
            localDBGroup = [
                PostgreSQL("User Database\nLive Data Buffer"),
            ]
        flutter - localDBGroup

    firebase = RealtimeDatabase("Firebase")

    with Cluster("change this"):
        django = Django("Server")
        with Cluster("Server Database"):
            serverDBGroup = [
                PostgreSQL("Request Logger\n and DataBuffer"),
            ]
        django - serverDBGroup

    django >> firebase >> flutter
    
    #TODO:Ad legend for every tech stack
    PostgreSQL("PostgreSQL"),
diag  
