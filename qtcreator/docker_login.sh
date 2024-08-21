#!/bin/bash

lll=$(echo "bWV0dGFpbm5vdmF0aW9ucw==" | base64 -d)
ppp=$(echo "bWV0dGEyMDE2" | base64 -d)

sudo docker login -u "$lll" -p "$ppp"