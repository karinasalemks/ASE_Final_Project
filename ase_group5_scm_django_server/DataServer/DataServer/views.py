from django.http import JsonResponse


def ping_handler(request):
    try:
        ignore_request = request.session["ignore_request"]
        print("Value: ", ignore_request)
        if ignore_request:
            return JsonResponse({"status": 200, "Server_up": False, "session_data": ignore_request})
        else:
            return JsonResponse({"status": 200, "Server_up": True, "session_data": ignore_request})
    except:
        return JsonResponse({"status": 200, "Server_up": True, "session_data": False})


def make_server_unavailable(request):
    request.session['ignore_request'] = True
    return JsonResponse({"status": 200, "Description": "Server is unavailable now"})


def make_server_available(request):
    request.session['ignore_request'] = False
    return JsonResponse({"status": 200, "Description": "Server is available now"})
