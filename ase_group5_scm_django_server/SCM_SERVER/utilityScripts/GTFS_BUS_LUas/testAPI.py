import requests
import json

headers = {
# Request headers
'Cache-Control': 'no-cache',
'x-api-key': 'e6f06c8f344e454f872d48addd6c23c6',
}

url = "https://gtfsr.transportforireland.ie/v1/?format=json"
response = requests.get(url, headers=headers)
bus_data = json.loads(response.text)
bus_trip_delays = bus_data["Entity"]

print(bus_trip_delays)