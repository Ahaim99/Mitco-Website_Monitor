Web Monitor Documentatoin:

There are some folders to distribute files

1- db
2- FindUniqueScript
    index.py (Python Script)
        This Script fetch website html (5 different attemps) and process to get the unique part of HTML, this part is saved in database table "website_monitoring.monitored_sites" for use of tracking script.

3- monitor script
    index.pl (Perl Script)
        This Script Fetch records fro database and process these URLs one by one and if any website getting Critical breakdown, this script send a email to the registered email and set its status to "inactive".

4- README.md