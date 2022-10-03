#!/bin/bash

url=$1

if [ ! -d "$url" ];then

    mkdir $url

fi

if [ ! -d "$url/recon" ];then

    mkdir $url/recon

fi

if [ ! -d "$url/recon/httprobe" ];then

    mkdir $url/recon/httprobe

fi

if [ ! -f "$url/recon/httprobe/alive.txt" ];then

    touch $url/recon/httprobe/alive.txt

fi

if [ ! -f "$url/recon/final.txt" ];then

    touch $url/recon/final.txt

fi

 

echo "[+] Harvesting subdomains with assetfinder..."

assetfinder $url >> $url/recon/assets.txt

cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt


wc -l $url/recon/assets.txt | grep -o '[[:digit:]]*'

echo -------------------------------------

echo "[+] Harvesting subdomains with subfinder..."

subfinder -d  $url --silent >> $url/recon/subfinder.txt

cat $url/recon/subfinder.txt | grep $1 >> $url/recon/final.txt

echo ------------COUNT--------------------

wc -l $url/recon/subfinder.txt | grep -o '[[:digit:]]*'

echo "[+] Harvesting subdomains with Finddomain..."

findomain -t  $url -q >> $url/recon/findomain.txt

cat $url/recon/findomain.txt | grep $1 >> $url/recon/final.txt

echo ------------COUNT--------------------

wc -l $url/recon/findomain.txt | grep -o '[[:digit:]]*'

echo -------------------------------------

echo "[+] Harvesting subdomains with sublist3r..."

sublist3r -d $url  >> $url/recon/sublist3r.txt

cat $url/recon/sublist3r.txt | grep $1 >> $url/recon/final.txt

echo ------------COUNT--------------------

wc -l $url/recon/sublist3r.txt | grep -o '[[:digit:]]*'

echo -------------------------------------


echo "[+] Double checking for subdomains with amass..."

amass enum -d $url >> $url/recon/f.txt

sort -u $url/recon/f.txt >> $url/recon/final.txt

wc -l $url/recon/f.txt | grep -o '[[:digit:]]*'

rm $url/recon/f.txt

 

echo "[+] Probing for alive domains..."

cat $url/recon/final.txt | sort -u | httpx >> $url/recon/httprobe/a.txt

sort -u $url/recon/httprobe/a.txt > $url/recon/httprobe/alive.txt

rm $url/recon/httprobe/a.txt


