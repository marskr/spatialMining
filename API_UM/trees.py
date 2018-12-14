#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : ztmAPI.py
# Author            : Marcin Skryskiewicz <marskr@opoczta.pl>
# Date              : 1.12.2018
# Last Modified Date: 1.12.2018
# Last Modified By  : Marcin Skryskiewicz <marskr@opoczta.pl>


import unicodedata
import requests
from API_connect.settings import APIkey

# self.URL - URL of warsaw API
# self.res_id - ID of resouce (provided by warsaw API)
# self.APIkey - key obtained after login in warsaw API network
# self.limit - amount of retrieved rows from warsaw API
# self.district - district of warsaw (for example 'Wola')

class Trees:
    def __init__(self, URL, res_id, APIkey, limit, district):
        self.URL = URL
        self.res_id = res_id
        self.APIkey = APIkey
        self.limit = limit
        self.district = district


    def getAllLineMeasures(self):
        params = {'resource_id': self.res_id, 'apikey': self.APIkey, 'limit': self.limit, 'q': self.district}

        # sending get request and saving the response as response object
        r = requests.get(url=self.URL, params=params)

        return r.json()

    def getTrees(self, data, nr):
		# retrieving particular columns from json 
        latitude = data["result"]["records"][nr]['y_wgs84']

        longitude = data["result"]["records"][nr]['\ufeffx_wgs84']

        health_state = data["result"]["records"][nr]['stan_zdrowia']

        trunk_circuit = data["result"]["records"][nr]['pnie_obwod']

        height = data["result"]["records"][nr]['wysokosc']

        id = data["result"]["records"][nr]['numer_inw']

        species = data["result"]["records"][nr]['gatunek']

        return (latitude, longitude, health_state, trunk_circuit, height, id, species)


def find_between(s, first, last):
    try:
        start = s.index(first) + len(first)
        end = s.index(last, start)
        return s[start:end]
    except ValueError:
        return ""


def preprocessData(fieldToConv):

    result = find_between(str(unicodedata.normalize('NFKD', fieldToConv).replace(u'ł', 'l').encode('ascii', 'ignore')), "'", "'")

    return result


URL = "https://api.um.warszawa.pl/api/action/datastore_search/"

res_id = "ed6217dd-c8d0-4f7b-8bed-3b7eb81a95ba"

tree = Trees(URL, res_id, APIkey, 100000, "Śródmieście")

# this commented part allows to measure localisation of buses/trams
data = tree.getAllLineMeasures()

# preprocessing data before sending to server
for i in range(0, len(data["result"]["records"]), 1):
    measure = tree.getTrees(data, i)

    file = open('treeMeasures.txt', 'a')
    file.write(str(measure[0]) + "\t" +
               str(measure[1]) + "\t" +
               str(preprocessData(measure[2])) + "\t" +
               # str(measure[3]) + "\t" +
               # str(measure[4]) + "\t" +
               str(measure[5]) + "\t" +
               str(preprocessData(measure[6])) + "\t" +
               str(5) + "\n")
    file.close()

