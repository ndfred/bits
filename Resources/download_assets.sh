#!/bin/sh -ex

cd "`dirname $0`"

if [ ! -f Icon-72@2x.png ]
then
  rm -f Logo.png Icon.png Icon@2x.png Icon-72.png Icon-72@2x.png
  curl -s -L -o Logo.png "https://api.twitter.com/1/users/profile_image?screen_name=nytimesbits&size=original"
  sips -Z 57 Logo.png --out Icon.png
  sips -Z 114 Logo.png --out Icon@2x.png
  sips -Z 72 Logo.png --out Icon-72.png
  sips -Z 144 Logo.png --out Icon-72@2x.png
  rm Logo.png
fi
