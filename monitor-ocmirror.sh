#!/bin/bash

#Example of the oc-mirror command to pull images from public registry to disk
# 
#oc mirror --verbose 3 --config=redhat-op-v4.16-config-v1.yaml file://disk-dwn-redhat-v1 2>&1 |tee /home/admin/ocmirror/ocmirror-logs/download-redhat-v416-mirrortodisk-v1-$(date +%Y%m%d-%HH%M).log
#

# Log file name
LOGFILE="/home/admin/ocmirror/ocmirror-logs/script-download-redhat-v416-mirrortodisk-v1-$(date +%Y%m%d-%HH%M).log"
# The oc-mirror command
LAUNCH="oc mirror --verbose 3 --config=script-redhat-op-v4.16-config-v1.yaml file://disk-script"
LOOPCOUNT=0;
MAXLOOP=20;
echo "--------------------------------"
echo "Starting the mirroring"
echo "Logs file:"
echo "$LOGFILE"
echo ""
echo "Command:"
echo "$LAUNCH"
echo ""
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
    elif [[ $LASTTENLINE == *"No updates detected, process stopping"* ]]
    then
      echo "No updates detected, process stopping"
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
    elif [[ $LOOPCOUNT -gt $MAXLOOP ]]
    then
      echo "The mirroring has stopped - ERROR LOOP more than 20 times"
      echo "look at the logs ${LOGFILE}"
      exit 5
    else
      ((LOOPCOUNT++))
      echo "Restarting the oc mirror command - $LOOPCOUNT/$MAXLOOP"
      echo "--------------------------------"
      echo "$LASTTENLINE"
      echo "--------------------------------"
      echo "--------------------------------------------------------------" >> "${LOGFILE}"
      echo "Monitor script stopped/restarted the mirroring - $LOOPCOUNT/$MAXLOOP" >> "${LOGFILE}"
      echo "--------------------------------------------------------------" >> "${LOGFILE}"
      continue
    fi
done
