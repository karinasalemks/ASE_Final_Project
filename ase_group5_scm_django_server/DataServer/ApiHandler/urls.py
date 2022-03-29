from django.urls import path, include

# from ASE_Final_Project.ase_group5_scm_django_server.DataServer.Server_DataTransformer.views import getBusTrips
from . import views

urlpatterns = [
    # url to get bike data
    path('bikes/', views.getBikeData),
    # add  url patterns for bus, luas and events here
    path('bustrips/', views.getBusData),
    path('weatherForecast/', views.aggregateWeatherForecast)
]
