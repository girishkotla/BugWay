#!/bin/bash

rm domains.txt

# Step 1: Take input of a list of domains
echo -e "Enter a list of domains (one per line). Press Ctrl+D when done:\n"
while IFS= read -r domain; do
    echo -e "$domain\n" >> domains.txt
done

# Inform the user that the search is beginning
echo -e "\nThe search began, wait for some time...\n"

# Step 2: Run subfinder and save output to a new list
subfinder -dL domains.txt -recursive -silent > new_list_subdomains.txt

echo -e "\nSubdomains were enumerated. Now checking for vulns. Come back after sometime.....\n"

# Step 3: Run subzy on the output of Step 2
subzy run --targets new_list_subdomains.txt --concurrency 100 | grep -v "ERROR\|NOT\|Unbounce"

# Optionally, you can save the output of Step 3 to a file if needed
# subzy run --targets new_list_subdomains.txt --concurrency 100 | grep -v "ERROR\|NOT" > final_output.txt
