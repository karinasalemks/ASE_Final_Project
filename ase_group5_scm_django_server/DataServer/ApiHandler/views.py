from django.shortcuts import render

# Create your views here.
from django.http import JsonResponse


def test_method(request):
    return JsonResponse({'a': 'b'})
