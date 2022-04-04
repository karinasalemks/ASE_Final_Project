# API Endpoint Settings
DUBLIN_BIKES_API = {
    "source": "/getData/bikes/",
    # TODO: split individual api end points into base url, host, port and the source
    # "host":"http://127.0.0.1:",
    # "port":"",
}

DUBLIN_BUSES_API = {
    "source": "/getData/bustrips/",
    "busStops":"/getData/getBusStops/",
}

DUBLIN_EVENTS_API = {

}

DUBLIN_LUAS_API = {
    "source": "/getData/getLuasData/",
    "stops": "/getData/getLuasStops/",
}
