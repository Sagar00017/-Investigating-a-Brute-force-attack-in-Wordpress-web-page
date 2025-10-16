LOS Lab Assignment 

 
An application using globbing, grep, sed and awk in cybersecurity. 
 
Analyzing web server logs to detect and summarize potential brute-force attack. 
 
--> Investigating a suspicious activity on an Apache web server. 
--> Requirement: find ip address that are repeatedly trying to access the “wp-login.php” page. And block the particular ip’s which has made brute-force attack. 
 
The Scenario: Investigating a Brute-force attack 
--> check the “wp-login.php” page go through the “access.log” file and check which system’s ip address was doing brute-force attack. 
--> List out the few top most (10) ip address to block the particular ip address. 
 
Globbing 
 
sudo cat access.log* 
 
access.log - actual file to look into where all failed login data will be present 
*  --> wild card that matches all kind of access.log 

Grep 
 
grep “POST /wp-login.php” 
 
This will search for POST /wp-login.php pattern in access.log file. This POST /wp-login.php will give the results lines that contain requests for the login page specifically those that are POST requests (which is how login forms are submitted). 
 
Sed 
 
sed ‘sed/”//g’  
 
Imagine some of your log entries have the IP address wrapped in unnecessary quotation marks, while others don't. This inconsistency can confuse other tools like awk. 
 

 

 

 
Example of messy log data: 
"198.51.100.14" - - [16/Oct/2025:11:00:15 +0530] "POST /wp-login.php ... 

" 203.0.113.88 - - [16/Oct/2025:11:01:20 +0530] "POST /wp-login.php ..."  

"198.51.100.14" - - [16/Oct/2025:11:02:35 +0530] "POST /wp-login.php ..." 

If you send this directly to awk, you would get inconsistent output: 

"198.51.100.14" (with quotes) 

203.0.113.88 (without quotes) 

We can use sed to fix this first. 
 
AWK 
Once you have the relevant log entries, you need to extract just the attacker's IP address from each line. Apache logs have a standard format, and the IP address is typically the first field. awk is perfect for field-based data extraction. We'll tell it to print the first column ($1). 
 
awk ‘{print $1} 

$1 – will print the first column where ip address will be present. 

Sort 

sort | uniq -c | sort -nr | head -n 10 

Receives the raw list of IP addresses from awk. 

Sorts them alphabetically/numerically, which groups all identical IPs together. 

 

 

uniq –c 

uniq -c 

Receives the sorted list of IPs. 

Collapses the groups of identical IPs into single lines and adds a count (-c) of how many times each appeared. The output looks like: 251 198.51.100.14. 

sort –nr 

sort -nr 

Receives the counted list from uniq. 

Sorts the list numerically (-n) and in reverse order (-r), putting the IPs with the highest counts at the top. 

head -n 10 

Receives the fully sorted list. 

Displays only the top 10 lines, giving you a clean report of the worst offenders. 

 

 

Final commands 

cat access.log* | grep “POST /wp-login.php” | sed ‘s/”//g’ | awk ‘{print $1}’ | sort | uniq –c | sort –nr | head –n 10 

Converting these commands to a shell script. Name: analyse_logs.sh 

 

#!/bin/bash 

# A simple script to find the top 10 IPs from a WordPress brute-force attempt.  

echo "--- Finding Top 10 Attacking IPs ---" 

cat access.log* | grep "POST /wp-login.php" | sed 's/"//g' | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10 

echo "------------------------------------" 
 
 
access.log file 
 

 
Output: 
 
 
After getting these ip’s the security analyst can block these ip’s. 

 
 
