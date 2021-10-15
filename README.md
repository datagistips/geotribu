# Géotribu
Reformater, nettoyer, analyser les revues de presse [Géotribu](http://static.geotribu.fr/)

## `reformatRdp`
Exemple d'une rdp mal formatée : https://static.geotribu.fr/rdp/2011/rdp_2011-12-23/#open-data

### Avantn/Après, log
Exemple pour le 21 Janvier 2011 :

- rdp **avant** : https://github.com/geotribu/website/blob/fenfyx2/content/rdp/2011/rdp_2011-01-21.md
- rdp **après** : https://github.com/geotribu/website/blob/fenfyx2/content/rdp/2011/rdp_2011-01-21-new.md
- **log** des modifs : https://github.com/geotribu/website/blob/fenfyx2/content/rdp/rdp_2011-01-21-log.md

### Cas traités
Reformate les cas suivants :

	### L'Open Data en image** lorem ipsum
	## L'Open Data en image** lorem ipsum
	L'Open Data en image** lorem ipsum
	 **OpenLayers Mobile**  lorem ipsum
	![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**gvSIG** lorem ipsum

## TODO
- [x] Reformater les titres
- [ ] Trouver les liens morts : images,...
- [ ] Créer un JSON depuis une rdp :
	- thumbnail
	- catégorie
	- liens
	- images
	- technos identifiées
- Libérer le JSON

## VIZ
- Compter les catégories barplot avec d3
- voir adjectif après carte
- voir les noms de domaines les plus fréquents
- voir les technos dont on a parlé
- suivre la quantit? de rdps dans le temps, là où il n'y en a pas
- voir le mot clé QGIS, MapBox, IGN, OpenData, Data, Data Science, Intelligence artificielle
- Les jours de publication de la rdp
- beeswarm ou word cloud temporel
- topic modeling ?
- Nb de mots
- Nb de news
- En fonction du logo : type de news
- Transformer les news en JSON
- Sortie de la semaine en niveau 4, doit être en niveau 2..