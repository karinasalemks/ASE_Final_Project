from ipaddress import ip_address
from urllib import request
from django.shortcuts import render
from grpc import server
import requests
import time
from collections import deque
 
# Create your views here.
class Server:
    def __init__(self,server_name,host_address,port,is_master=False) -> None:        
        self.server_name = server_name
        self.host_address = host_address
        self.port = port
        self.is_master = is_master
    
    def is_available(self):
        server_available = False
        latency = -1
        availability_endpoint = "http://"+self.host_address+":"+self.port+"/availability/"
        try:
            start_time = time.time()
            response = requests.get(availability_endpoint)
            end_time = time.time()
            server_available = True
            print(f"[INFO] Server: {self.server_name} is available")
            latency = end_time-start_time
        except Exception as e:
            print("Server not available",e)
        return server_available,latency
    
    def request_data_server(self,path):
        target_url = "http://"+self.host_address+":"+self.port+path
        print(f"[INFO] Sending Request to Server: {self.server_name}")
        response = requests.get(target_url)
        return response

available_servers = deque()
available_servers.append(Server("Alpha","127.0.0.1","7000",is_master=True))
available_servers.append(Server("Beta","127.0.0.1","7001"))
available_servers.append(Server("Gamma","127.0.0.1","7002"))

def send_request(path):
    #Decide the data server where the request has to be routed
    minimum_latency = float("inf")
    while True:
        target_server = available_servers.popleft()
        is_available, latency = target_server.is_available()
        if is_available:
            break
        else:
            available_servers.append(target_server)
    
    #Actual request to data server
    result = target_server.request_data_server(path)

    #Add the target server to the queue
    available_servers.append(target_server)
    return result





                
    