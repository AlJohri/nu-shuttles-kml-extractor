# coding: utf-8

import urllib, re
from bs4 import BeautifulSoup as bs

uid = '209440134627172181780'
start = 0
shown = 1

while True:
    url = 'http://maps.google.com/maps/user?uid='+uid+'&ptab=2&start='+str(start)
    source = urllib.urlopen(url).read()
    soup = bs(source)
    maptables = soup.findAll(id=re.compile('^map[0-9]+$'))
    for table in maptables:
        for line in table.findAll('a', 'maptitle'):
            mapid = re.search(uid+'\.([^"]*)', str(line)).group(1)
            mapname = re.search('>(.*)</a>', str(line)).group(1).strip()[:-2]
            print shown, mapid, mapname
            shown += 1

            # uncomment if you want to download the KML files:
            # urllib.urlretrieve('http://maps.google.com.br/maps/ms?msid=' + uid + '.' + str(mapid) + '&msa=0&output=kml', mapname + '.kml')                

    if '<span>Next</span>' in str(source):
        start += 5
    else:
        break

# just copied and pasted with different uid

uid = '200725481515120343586'
start = 0
shown = 1

while True:
    url = 'http://maps.google.com/maps/user?uid='+uid+'&ptab=2&start='+str(start)
    source = urllib.urlopen(url).read()
    soup = bs(source)
    maptables = soup.findAll(id=re.compile('^map[0-9]+$'))
    for table in maptables:
        for line in table.findAll('a', 'maptitle'):
            mapid = re.search(uid+'\.([^"]*)', str(line)).group(1)
            mapname = re.search('>(.*)</a>', str(line)).group(1).strip()[:-2]
            print shown, mapid, mapname
            shown += 1

            # uncomment if you want to download the KML files:
            # urllib.urlretrieve('http://maps.google.com.br/maps/ms?msid=' + uid + '.' + str(mapid) + '&msa=0&output=kml', mapname + '.kml')

    if '<span>Next</span>' in str(source):
        start += 5
    else:
        break

