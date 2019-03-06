#!/usr/bin/env bash

# ---------------------------------------------------------------------------------------
# Bash script to monitor or watch the disk space
# It will send an email to $ADMIN_EMAIL, if the (free available) percentage of space is >= 90%.
# 
# Save this somewhere on your system, this example assumes it is stored within the '/root'
#
# Usage:
#   sudo bash /low-space-checker.sh
#
# CRON Usage:
#   0 * * * * bash /low-space-checker.sh
# ---------------------------------------------------------------------------------------

# Set an email address so you can receive notifications
ADMIN_EMAIL="email@example.com"

# Set the mountpoint - this is the partition that will be checked
#MOUNT_POINT="/"
#MOUNT_POINT="/srv/dev-disk-by-label-maxtorm3"
MOUNT_POINT="/dev/sda1"

# Set an alert level. 90% is the default
ALERT=90

# Exclude list of unwanted monitoring, if several partions, then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/dev/hdd1|/dev/hdc5"
EXCLUDE_LIST=""



# --------------------------- NOTHING TO EDIT PAST THIS POINT ---------------------------

# Main program
function main_prog() {

    # Loop and read the output from df, grep and awk
    while read output;
    do
        
        # Setup variables
        usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)    # Find current usage
        partition=$(echo $output | awk '{print $2}')                # Find this current partition
        
        # If Usage is greater than the alert threshold
        if [ $usep -ge $ALERT ] ; then
        
            # Find the largest folders/files within the mountpoint
            filetree=$(du -h --max-depth=1 $MOUNT_POINT | sort -hr)
        
            # Send email: Set body and then use the 'mail' command
            echo $'Running out of space '"$partition ($usep%)"$' on server '"$(hostname)"$',\n\nThese are the largest folders/files:\n'"$filetree"$'\n\nPlease check fix this as soon as possible.\n\nThis email was generated on: '"$(date)" | \
            mail -s "Alert: Almost out of disk space $usep%" $ADMIN_EMAIL
            
        fi
        
    done
}


# If there is anything within the exclude list, calculate the free storage threshold excluding the files in this list
if [ "$EXCLUDE_LIST" != "" ] ; then
  df -H $MOUNT_POINT | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | main_prog
  
# Anything else, calculate free storage threshold
else
  df -H $MOUNT_POINT | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | main_prog
fi