from django.test import TestCase
import pandas as pd
import numpy as np
import io

# Create your tests here.

#recent_df = pd.read_csv('../static/StationID_Recent_Observations - Copy.csv')
recent_df = pd.read_csv('../static/StationID_Recent_Observations.csv')
recent_dict = {recent_df.loc[index, 'stationID']:index for index in recent_df.index}

print(recent_dict)

#maxBikes_dict = station_maxBikes_df.set_index('stationID').to_dict()


station_id = '10'
availableBikes = 20
station_index = recent_dict[int(station_id)]

recent_df.set_index('stationID', inplace=True)
recent_string = recent_df.loc[int(station_id)].recentObservations
print(recent_string)
print(np.fromstring(recent_string))
#recent_list = np.fromstring(recent_df.loc[int(station_id)].recentObservations, sep=',')
#recent_list = np.fromstring(recent_df.loc[int(station_id)].recentObservations, dtype='int64')
print(np.frombuffer(recent_df.loc[int(station_id)].recentObservations))
#recent_list = np.frombuffer(recent_df.loc[int(station_id)].recentObservations)
#recent_list.concatenate(availableBikes)
#recent_list = np.arange(100,120)
print("START")
print(recent_list)
print(recent_list.size)

updated_list = np.empty(20)
updated_list[:19] = recent_list[1:]
updated_list[19] = availableBikes

# for i, row in recent_df.iterrows():
#     recent_df.at[i,'recentObservations'] = updated_list.tobytes()

#recent_df.loc[int(station_id)].recentObservations = updated_list
#recent_df.iloc[:].recentObservations = updated_list
print(recent_df.loc[int(station_id)].recentObservations)

recent_df.to_csv('../static/StationID_Recent_Observations.csv')

# for i in np.arange(1,21):
#     updated_list = np.empty(20)
#     updated_list[:19] = recent_list[1:]
#     updated_list[19] = i
#     recent_list = updated_list
#     print(recent_list)



#recent_df.iloc[station_index]
#recent_df.loc[4]