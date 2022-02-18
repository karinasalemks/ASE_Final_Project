from django.urls import path, include
from . import views

urlpatterns = [
    path('bikes/', views.getBikeData)
    # add  url patterns for bus, luas and events here
]
