from django.urls import path
from . import views

urlpatterns=[    
    path('bikeAvailability/', views.bikeAvailability, name="availability"),
]