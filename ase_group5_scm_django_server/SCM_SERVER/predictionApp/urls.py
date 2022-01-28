from django.urls import path
from . import views

urlpatterns=[    
    path('predictionDublinbikes/', views.predictionDublinBikes),

]