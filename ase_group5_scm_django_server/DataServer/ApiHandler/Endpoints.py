# API Endpoint Settings

DUBLIN_BIKES_API = {
    "PRIMARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "SECONDARY": "https://api.jcdecaux.com/vls/v1/stations?contract=dublin&apiKey=6569b95fc803bdb3f3112f0ec2e149d7769c5183",
    "OTHER_SOURCES": [],
}

DUBLIN_BUSES_API = {
    "PRIMARY": "https://gtfsr.transportforireland.ie/v1/?format=json"
}

DUBLIN_BUS_HEADER = {
    # Request headers
    'Cache-Control': 'no-cache',
    'x-api-key': 'e6f06c8f344e454f872d48addd6c23c6',
}

DUBLIN_EVENTS_API = {
    "PRIMARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "SECONDARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "OTHER_SOURCES": [],
}

DUBLIN_LUAS_API = {
    "PRIMARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "SECONDARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "OTHER_SOURCES": [],
}

WEATHER_FORECAST_API = {
    "PRIMARY": "http://metwdb-openaccess.ichec.ie/metno-wdb2ts/locationforecast?lat=53.3498&long=-6.2603&from=",
    "SECONDARY": "http://metwdb-openaccess.ichec.ie/metno-wdb2ts/locationforecast?lat=53.3498&long=-6.2603&from=",
    "OTHER_SOURCES": [],
}

WEATHER_WARNING_API = {
    "PRIMARY": "https://www.met.ie/Open_Data/json/warning_EI07.json",
    "SECONDARY": "https://www.met.ie/Open_Data/json/warning_EI07.json",
    "OTHER_SOURCES": [],
}
