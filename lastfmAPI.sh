#!/bin/bash

# Script to use the lastFM API
# Written by: Hubert Léveillé Gauvin
# Date: 27 December 2017
# Last update: 29 December 2017

# NOTES: 

# 	To use the lastFM API, you first need to create an API account at: 
#	https://www.last.fm/api/account/create
# 	Use your regular lastFM username and password to create your developper app. 
#	The app can be called anything.

# BUGS:

#	o album.getInfo: autocorrect doesn't work.

# set -x

#----INSERT YOUR PEROSNAL INFORMATION HERE------------------------------------------------
app_name="INSERT APP NAME HERE"		# optional
key="INSERT KEY HERE" 
secret="INSERT SECRET HERE"				# optional
registered_to="INSERT USER ID HERE"	# optional 
#-----------------------------------------------------------------------------------------



#----DEFAULT OPTIONS: CHANGE AS NEEDED----------------------------------------------------
limit=50
page=1
format="json"		# json or xml
#-----------------------------------------------------------------------------------------



#----FUNCTIONS----------------------------------------------------------------------------
check_dependency(){
if command -v $1 >/dev/null 2>&1 ; then
:
else
    echo -e "\033[0;31m'$1': command not found.\033[0m. Some functionality may be unavailable."
fi
}
#-----------------------------------------------------------------------------------------



#----CHECK DEPENDENCIES-------------------------------------------------------------------
check_dependency jq
#-----------------------------------------------------------------------------------------



#----INSTRUCTIONS-------------------------------------------------------------------------
echo
echo "This is a simple interface to interact with the last.fm API."
echo
echo "For more info about API Methods, visit: "
echo "https://www.last.fm/api"
echo
#-----------------------------------------------------------------------------------------



#----DISPLAY OPTIONS----------------------------------------------------------------------
echo "Choose from one of the following methods:"
echo
echo -e "album.getInfo\nalbum.getTopTags\nalbum.search"
echo
echo -e "artist.getInfo\nartist.getSimilar\nartist.getTopAlbums\nartist.getTopTags\nartist.getTopTracks\nartist.search"
echo
echo -e "chart.getTopArtists\nchart.getTopTags"
echo
echo -e "geo.getTopArtists"
echo
echo -e "tag.getInfo\ntag.getTopAlbums\ntag.getTopArtists\ntag.getTopTags\ntag.getTopTracks\ntag.getWeeklyChartList"
echo
echo -e "track.getInfo\ntrack.getSimilar\ntrack.getTopTags\ntrack.search"
echo
#-----------------------------------------------------------------------------------------



#----CHOOSE METHOD------------------------------------------------------------------------
while :
do
read -p "Enter an API method (e.g. tag.getTopTags) or type 'MORE' for more options: " method

case $method in

album.getInfo|album.getTopTags)
		
		IFS= read -p "Enter an artist name (e.g. Cher, The Beatles): " artist
		artist=$(sed 's/ /+/g' <<< "$artist")
		IFS= read -p "Enter an album name (e.g. Rubber Soul): " album
		album=$(sed 's/ /+/g' <<< "$album")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&api_key=$key&artist=$artist&autocorrect=1&album=$album&format=$format")
		break
		;;
	
album.search)
		
		IFS= read -p "Enter an album name (e.g. Rubber Soul): " album
		album=$(sed 's/ /+/g' <<< "$album")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&api_key=$key&album=$album&format=$format")
		break
		;;	
	artist.getInfo|artist.getSimilar|artist.getTopAlbums|artist.getTopTags|artist.getTopTracks|artist.search)
		
		IFS= read -p "Enter an artist name (e.g. Cher, The Beatles): " artist
		artist=$(sed 's/ /+/g' <<< "$artist")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&artist=$artist&api_key=$key&autocorrect=1&format=$format")
		break
		;;
	
	geo.getTopArtists)
		
		IFS= read -p "Enter a country name (e.g. United States, Spain): " country
		country=$(sed 's/ /+/g' <<< "$country")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&country="$country"&api_key=$key&limit=$limit&page=$page&format=$format")
		break
		;;

	tag.getInfo|tag.getSimilar|tag.getTopAlbums|tag.getTopArtists|tag.getTopTracks)
	
		read -p "Enter a tag (e.g. Disco): " tag
		tag=$(sed 's/ /+/g' <<< "$tag")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&tag=$tag&api_key=$key&limit=$limit&page=$page&format=$format")
		break
		;;
	
	chart.getTopArtists|chart.getTopTags|tag.getTopTags|tag.getWeeklyChartList)
	
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&api_key=$key&limit=$limit&page=$page&format=$format")
		break
		;;
		
	track.getInfo|track.getSimilar|track.getTopTags|track.search)
	
		IFS= read -p "Enter an artist name (e.g. Cher, The Beatles): " artist
		artist=$(sed 's/ /+/g' <<< "$artist")
		IFS= read -p "Enter a track name (e.g. Michelle): " track
		track=$(sed 's/ /+/g' <<< "$track")
		url=$(echo "https://ws.audioscrobbler.com/2.0/?method=$method&api_key=$key&artist=$artist&autocorrect=1&track=$track&format=$format")
		break
		;;

	MORE|more)
	
		read -p "Enter your URL here: https://ws.audioscrobbler.com/2.0/" url
		url=$(echo "https://ws.audioscrobbler.com/2.0/$url")
		
		grep -q "format=json" <<< "$url"
		if [[ $? -eq 0 ]]; then
		format="json"
		else
		format="xml"
		fi
		break
		;;

	*)
		echo -e "\033[0;31mInvalid option.\033[0m"
esac
done
#-----------------------------------------------------------------------------------------



#----PRINT RESULTS------------------------------------------------------------------------
if [[ $format == "json" ]]; then
curl -s $url > lastOutput.json
jq '.' lastOutput.json
elif [[ $format == "xml" ]]; then
curl -s $url > lastOutput.xml
cat lastOutput.xml
fi
#-----------------------------------------------------------------------------------------
