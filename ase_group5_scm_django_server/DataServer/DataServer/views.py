from django.http import JsonResponse


def ping_handler(request):
    return JsonResponse({"status":200})