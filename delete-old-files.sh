#!/usr/bin/env bash

# ---------------------------------------------------------------------------------------
# Bash script to recursively delete files within a specific folder if older than X amount of days
# 
# Save this somewhere on your system, this example assumes it is stored within the '/root'
#
# Usage:
#   sudo bash /delete-old-files.sh
#
# CRON Usage:
#   0 * * * * bash /delete-old-files.sh
# ---------------------------------------------------------------------------------------

# Set the folder - this is the folder which holds the content (files and sub-folders) to be deleted
FOLDER="/home/username/examplefolder/"

# Specify the how old the file should be in-order to be deleted (days)
OLDER_THAN_DAYS="25"



# --------------------------- NOTHING TO EDIT PAST THIS POINT ---------------------------

# Find files within folder and delete if older than X amount of specific days
find $FOLDER -type f -mtime +$OLDER_THAN_DAYS -exec rm {} +> /dev/null 2>&1