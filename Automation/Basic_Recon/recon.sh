#!/bin/bash

domain=$1
wordlist="/root/tools/SecLists/Discovery/DNS/deepmagic.com-prefixes-top500.txt"
resolvers="/root/tools/shuffledns/resolvers.txt"

domain_enum(){

mkdir -p /root/workspace/$domain /root/workspace/$domain/sources /root/workspace/$domain/Recon
subfinder -d $domain -o /root/workspace/$domain/sources/subfinder_results.txt
assetfinder -subs-only $domain | tee /root/workspace/$domain/sources/assetfinder_resuls.txt
amass enum -passive -d $domain -o /root/workspace/$domain/sources/amass_passive_results.txt
shuffledns -d $domain -w $wordlist -r $resolvers -o /root/workspace/$domain/sources/shuffledns_results.txt

cat /root/workspace/$domain/sources/*.txt > /root/workspace/$domain/sources/all.txt
}
domain_enum

resolving_domains(){
shuffledns -d $domain -list /root/workspace/$domain/sources/all.txt -o /root/workspace/$domain/domains_resolved.txt -r $resolvers
}
resolving_domains


http_probe(){
cat /root/workspace/$domain/domains_resolved.txt | httpx -threads 200 -o /root/workspace/$domain/Recon/httpx.txt
}
http_probe
