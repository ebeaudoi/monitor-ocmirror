#!/bin/bash

#Example of the oc-mirror command to pull images from public registry to disk
# 
#oc mirror --verbose 3 --config=redhat-op-v4.16-config-v1.yaml file://disk-dwn-redhat-v1 2>&1 |tee /home/admin/ocmirror/ocmirror-logs/download-redhat-v416-mirrortodisk-v1-$(date +%Y%m%d-%HH%M).log
#

# Log file name
LOGFILE="/home/admin/ocmirror/ocmirror-logs/script-download-redhat-v416-mirrortodisk-v1-$(date +%Y%m%d-%HH%M).log"
# The oc-mirror command
LAUNCH="oc mirror --verbose 3 --config=script-redhat-op-v4.16-config-v1.yaml file://disk-script"

while :
do
    echo "New launch at `date`" >> "${LOGFILE}"
    ${LAUNCH} >> "${LOGFILE}" 2>&1 &
    wait
    LASTTENLINE=$(tail -10 "${LOGFILE}")
    if [[ $LASTTENLINE == *"looking for metadata file at"* ]]
    then
      echo "The mirroring has succeeded"
      echo "look at the logs ${LOGFILE}"
      exit;
    elif [[ $LASTTENLINE == *"manifest unknown"* ]]
    then
      echo "The mirroring has stopped - MANIFEST ERROR"
      echo "look at the logs ${LOGFILE}"
      exit 3
    elif [[ $LASTTENLINE == *"error rendering"* ]]
    then
      echo "The mirroring has stopped - ERROR RENDERING"
      echo "look at the logs ${LOGFILE}"
      exit 4
    else
      echo "Restarting the oc mirror command"
      echo "--------------------------------"
      echo "$LASTTENLINE"
      echo "--------------------------------"
      echo "----------------------------------------------" >> "${LOGFILE}"
      echo "Monitor script stopped/restarted the mirroring" >> "${LOGFILE}"
      echo "----------------------------------------------" >> "${LOGFILE}"
      continue
    fi
done
