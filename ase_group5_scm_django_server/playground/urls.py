from django.urls import path
from . import views

urlpatterns=[
    
    path('dublinbike/', views.dublinbike),
    path('test/', views.test),
    
]