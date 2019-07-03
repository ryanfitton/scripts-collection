#!/bin/bash

## Usage: delete-old-files-v2.sh
##
## Make the script executable:
##   chmod +x delete-old-files-v2.sh
##
## Pass arguments to the script:
##   1: PATH		: The file path relative to /root (/) of the folder which will be checked for files. This is Recurive, any files which match the find query (path and age) within each sub-folder will be deleted.
##   2: EXTENSION	: The file extension used by the find command, any files with this extension will be deleted.
##   3: AGE			: The age of files to be delated. Specify this in days, any files older than this value will be deleted.
##
## Run using:
##   sudo ./delete-old-files-v2.sh '/your-path-here/' 'mp4' '30'
##
## Notes: '/' = Server root folder. '~/' = User's home folder.


# Deletion options
PATH="$1"           		# The file path, this is recursive (files within sub-directories will be deleted)
EXTENSION="$2"           	# The file extension used to target files
AGE="$3"           			# (In days) If files are older than this value, they will be deleted



# -------------------- Nothing to change after this point --------------------

# Clear terminal window
clear

# Welcome/Start message
echo "****************************************"
echo "File deletion script"
echo "Created for Ubuntu operating systems"
echo "Author: Ryan Fitton (ryanfitton.co.uk)"
echo "Version 2.0.0"
echo "****************************************"

printf "\n"

echo "Starting in 5 seconds."
echo "..."
printf "\n"
sleep 5s # Wait 5 seconds


# Check if the passed required arguments are not empty
if [ "$1" != '' ] || [ "$2" != '' ] || [ "$3" != '' ];

# If none of these arguments are empty, the script can proceed
then


	#Run the script
	find $PATH -type f -name "*.$EXTENSION" -mtime +$AGE -exec rm {} +> /dev/null 2>&1

	echo "Deletion script has been run."
	printf "\n"

	exit 0 # Successful exit
  
  
# If one or more arguments are empty, produce an error
else
    echo "One or more arguments are empty."

    exit 1 # Exit with general error
fi
