# lastfmAPI
simple interface to interact with the last.fm API

Script to use the lastFM API

Written by: Hubert Léveillé Gauvin

Date: 27 December 2017, last revised: 29 December 2017

## Getting Started:
To use the lastFM API, you first need to create an API account at:

https://www.last.fm/api/account/create

Use your regular lastFM username and password to create your developper app. The app can be called anything.

Open `./lastfmAPI.sh` and modify the file by entering your lastFM developper information, including your lastFM API key.
You can also modify default options, like the the page number to fetch, the number of results per page, and the format (json or xml).	
Once this is done, save the file.

Make `lastfmAPI.sh` executable

	chmod +x ./lastfmAPI.sh

## Using the API for the first time:
Every time you use this script, your client key is used to send a request to the lastFM API. This is done silently but can sometimes take a few seconds.

Choose one of the API methods and enter the required information as prompted. For more information about the different methods, visit: https://www.last.fm/api

The `MORE` option allows you to manually enter a URL. This can be useful if the method your are looking for is not available from the list, want to search using mbid, or if you want to momentarily change the format rom json to xml (or vice versa).

## Accessing your results
The results of your last query are automatically saved in a file called `lastOutput.json` or `lastOutput.xml`.
To retrieve specific info from your last query, you can use `cat lastOutput.json | jq '<YOURCOMMAND>'` , or `cat lastOutput.xml`

Example: 

	cat lastOutput.json | jq '.tempo'

For more info about `jq`, visit: https://stedolan.github.io/jq/

## Examples
1) Create a csv file with songs and artists based on a tag

```
  method=tag.getTopTracks
  tag=Disco
  
  jq '.tracks.track | .[] | [.name, .artist.name] | @csv' lastOutput.json | sed 's/^"//g' | sed 's/"$//g' | sed s'/\\//g'
```

2) Create a csv with the most popular tags and their count for for a specific song
```
	method=track.getTopTags
	artist=The Beatles
	track=Michelle

	jq '.toptags.tag | .[] | [.name, .count] | @csv' lastOutput.json | sed 's/^"//g' | sed 's/"$//g' | sed s'/\\//g'
```
