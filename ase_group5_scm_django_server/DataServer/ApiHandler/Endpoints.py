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
    "PRIMARY": "https://app.ticketmaster.com/discovery/v2/events.json?venueId=",
    "OTHER_SOURCES": [],
}

DUBLIN_LUAS_API = {
    "PRIMARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "SECONDARY": "https://data.smartdublin.ie/dublinbikes-api/last_snapshot/",
    "OTHER_SOURCES": [],
}
