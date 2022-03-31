# API Endpoint Settings
DUBLIN_BIKES_API = {
    "source": "http://127.0.0.1:7000/getData/bikes/",
    # TODO: split individual api end points into base url, host, port and the source
    # "host":"http://127.0.0.1:",
    # "port":"",
}

DUBLIN_BUSES_API = {
    "source": "http://127.0.0.1:7000/getData/bustrips/",
    "busStops":"http://127.0.0.1:7000/getData/getBusStops/",
}

DUBLIN_EVENTS_API = {

}

DUBLIN_LUAS_API = {
    "source": "http://127.0.0.1:7000/getData/getLuasData/",
}