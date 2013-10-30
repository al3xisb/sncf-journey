Sncf Journey
============

Get the next arrivals or departures from the SNCF OpenData, which is a Beta API.  
This script retrieve TER and Intercités journeys only and cannot be use to get this informations:
* TGV journeys
* Realtime delays

Feel free to fork this repo, improve it and send commit.

## Requirements
You need Ruby to execute this script.

In order to get results you need an Internet connexion to access SNCF OpenData API.  
For more informations : http://test.data-sncf.com

## Instructions
This script can be use to retrive arrivals or departures.  
To do this, you need to use one this arguments and precise the city you want to retrieve informations.

For example, the list of arrival for Paris Austerlitz train station :
```
./lib/sncf -Arrivals 547000
Arrivals for Paris-Austerlitz (547000)
N°3620   | INTERCITÉS | Toulouse-Matabiau vers Paris-Austerlitz       | 13h18
N°3914   | INTERCITÉS | Bourges vers Paris-Austerlitz                 | 13h21
N°860610 | Train TER  | Châteaudun vers Paris-Austerlitz              | 13h34
N°14058  | INTERCITÉS | Tours vers Paris-Austerlitz                   | 13h46
N°860512 | Train TER  | Orléans vers Paris-Austerlitz                 | 14h05
```

Or the list of departures for Bordeaux:
```
./lib/sncf -Departures Bordeaux
Departures for Bordeaux-St-Jean (581009)
N°865623 | Train TER  | Bergerac vers Bordeaux-St-Jean                | 12h58
N°3830   | INTERCITÉS | Quimper vers Bordeaux-St-Jean                 | 13h08
N°865123 | Train TER  | St-Mariens-St-Yzan vers Bordeaux-St-Jean      | 13h49
N°865772 | Train TER  | Sarlat vers Bordeaux-St-Jean                  | 13h58
N°864823 | Train TER  | La Rochelle-Ville vers Bordeaux-St-Jean       | 14h03
```

### Why i can use my exact train station name ?
As the script can be use to either search for journeys and returns lists of stations, you cannot use some exact train station name if your train station return more than one search results.

For example, Paris returns exactly 10 train stations. 
```
./bin/sncf -Departures Paris
Modify your parameter and choose only one external code or city name
381863 | Cormeilles en Parisis
547000 | Paris Austerlitz
547026 | Paris Austerlitz souterrain
686667 | Paris Bercy
113001 | Paris Est
686006 | Paris Gare de Lyon
686030 | Paris Gare de Lyon souterrain
391003 | Paris Montparnasse
271007 | Paris Nord
271023 | Paris Nord Souterrain
384008 | Paris Saint-Lazare
```

More specific, 'Paris Austerlitz' returns 2 train stations.
```
./bin/sncf -Departures 'Paris Austerlitz'
Modify your parameter and choose only one external code or city name
547000 | Paris Austerlitz
547026 | Paris Austerlitz souterrain
```

Plus, you can use a shortened version of your train station name.  
For exeample, 'Limoges-B' instead of 'Limoges-Bénédictin'
```
./bin/sncf -Departures Limoges-B
Departures for Limoges-Bénédictins (592006)
N°868235 | Train TER  | Limoges-Bénédictins vers Périgueux            | 15h21m
N°3640   | INTERCITÉS | Brive-la-Gaillarde vers Paris-Austerlitz      | 16h06m
N°868010 | Train TER  | Limoges-Bénédictins vers Poitiers             | 16h10m
N°868756 | Train TER  | Limoges-Bénédictins vers Guéret               | 16h11m
N°861462 | Train TER  | Limoges-Bénédictins vers Vierzon              | 16h20m
```

### How to get my train station code ?
Each train station is describe as an unique stop area code (stopareaexternalcode).  
To get your train station code you only need to ask the script.

For example, i ask the list of arrival of Lyon. The script get more than one result and list all the trains train stations:
```
./lib/sncf Arrivals Lyon
Modify your parameter and choose only one external code or city name
282624 | Lyon Jean Macé
762906 | Lyon Saint-Exupéry TGV
721159 | Lyon Saint-Paul
721175 | Lyon-Gorge-de-Loup
723197 | Lyon-Part-Dieu
722025 | Lyon-Perrache-Voyageurs
721001 | Lyon-Vaise
686006 | Paris Gare de Lyon
686030 | Paris Gare de Lyon souterrain
```

### Why my train station doesn't show any journeys ?  
Some specifics train stations (even if they are available) aren't stop for TER or Intercités.

For example 'Marne la Vallée' is a train station that receives only TGV.
```
./lib/sncf -Arrivals Marne
Modify your parameter and choose only one external code or city name
116574 | Chézy sur Marne
382259 | Garches-Marnes la Coquette
175091 | Joinville (Haute-Marne)
116137 | Longueville (Seine-et-Marne)
111849 | Marne la Vallée-Chessy
142406 | Merrey (Haute-Marne)
171611 | Val-de-Vesle (Marne)
113795 | Villiers sur Marne-Le Plessis-Trévise

./lib/sncf -Arrivals 111849
Departures for Marne la Vallée-Chessy (111849)
```

## SNCF OpenData
All data are extract from SNCF OpenData :  http://test.data-sncf.com  
All train stations are localy stored in 'lib/data' file.

## License
MIT

## Author
Alexis Blandin
