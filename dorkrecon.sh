#!/usr/bin/bash

#COLOUR DECLARATION END
Black='\e[30m'
Yellow='\e[33m'
Blue='\e[93m'
DO="\e[1;97;95m"
PINK="\e[1;97;95m"
RED="\e[1;97;31m"
GREEN="\e[1;97;92m"
Gcyan="\e[1;97;93m"
Cyan="\e[1;97;96m"
STOP="\e[0m"


header() {
    echo -e "${DO}
    ####      ####    #####    ##  ##   #####    ######    ####     ####    ##  ##  
    ## ##    ##  ##   ##  ##   ## ##    ##  ##   ##       ##  ##   ##  ##   ### ##  
    ##  ##   ##  ##   ##  ##   ####     ##  ##   ##       ##       ##  ##   ######  
    ##  ##   ##  ##   #####    ###      #####    ####     ##       ##  ##   ######  
    ##  ##   ##  ##   ####     ####     ####     ##       ##       ##  ##   ## ###  
    ## ##    ##  ##   ## ##    ## ##    ## ##    ##       ##  ##   ##  ##   ##  ##  
    ####      ####    ##  ##   ##  ##   ##  ##   ######    ####     ####    ##  ## 
    ${STOP}"
    echo -e "${Cyan}Author: Amir Hamza @mr_vill4in"
    echo -e "${GREEN}Twitter: @mr_vill4in"
    echo -e "${Gcyan}Github: mr-vill4in"
    echo -e "${Yellow}Version: 1.0 ${STOP}"
}

header

if [ $# -eq 0 ]
then
    echo "Usage: ./dorkrecon.sh -f <dorkfile> -d <dork>"
    exit 1
fi

while getopts f:d: flag
do
    case "${flag}" in
        f) dorkfile=${OPTARG};;
        d) dork=${OPTARG};;
    esac
done

# tool check
if ! [ -x "$(command -v go-dork)" ]; then
  echo -e "${RED}Error: go-dork is not installed." >&2
  echo -e "${GREEN}Do you want to install go-dork? [y/n]"
    read answer
    if [ "$answer" == "y" ]
    then
        GO111MODULE=on go install dw1.io/go-dork@latest
    else
        echo -e"${RED}Please install go-dork and run the script again"
        exit 1
    fi
  exit 1
fi
if ! [ -x "$(command -v subfinder)" ]; then
  echo -e "${RED}Error: subfinder is not installed." >&2
    echo -e "${GREEN}Do you want to install subfinder? [y/n]"
        read answer
        if [ "$answer" == "y" ]
        then
            go get -v github.com/projectdiscovery/subfinder/cmd/subfinder@latest
        else
            echo -e "${RED}Please install subfinder and run the script again"
            exit 1
        fi
  exit 1
fi
if ! [ -x "$(command -v naabu)" ] ; then
  echo -e "${RED}Error: naabu is not installed." >&2
    echo -e "${GREEN}Do you want to install naabu? [y/n]"
        read answer
        if [ "$answer" == "y" ]
        then
            go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
        else
            echo -e "${RED}Please install naabu and run the script again"
            exit 1
        fi
  exit 1
fi

if ! [ -x "$(command -v nuclei)" ]; then
  echo -e "${RED}Error: nuclei is not installed." >&2
    echo -e "${GREEN}Do you want to install nuclei? [y/n]"
        read answer
        if [ "$answer" == "y" ]
        then
            go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
        else
            echo -e "${RED}Please install nuclei and run the script again"
            exit 1
        fi
  exit 1
fi


name=$(date | awk -F" " '{print $2$3$4}') # get the date and store it in name variable


if [ -f "$dorkfile" ]
then
    echo -e "${PINK}$dorkfile found."
    cat $dorkfile | while read line ; do
        echo "dork is $line"
        go-dork -q $line -p 5 -s | awk -F "/" '{print $3}' >> $name.dork
        subfinder -dL $name.dork -o sub.$name.dork 
        echo "sorting and removing duplicates"
        cat sub.$name.dork | sort -u >> sorted.$name.dork | tee -a sorted.$name.dork
        naabu -iL sorted.$name.dork -o naabu.$name.out -silent -rate 100  
        nuclei -l naabu.$name.out -s low,medium,high,critical -o nuclei.$name.out
        echo -e "${PINK}Done! ${STOP}"
    done
else
    echo -e "${PINK}Your dork is $dork ${STOP}"
    go-dork -q "$dork" -p 5 -s | awk -F "/" '{print $3}' >> $name.dork
    subfinder -dL $name.dork -o sub.$name.dork
    echo "Sorting and removing duplicates"
    cat sub.$name.dork | sort -u >> sorted.$name.dork | tee -a sorted.$name.dork
    naabu -iL sorted.$name.dork -o naabu.$name.out -silent -rate 100  
    nuclei -l naabu.$name.out -s low,medium,high,critical -o nuclei.$name.out
    echo -e "${PINK}Done! ${STOP}"
fi
