#!/bin/bash
vboxmanage list runningvms | while read line; do
  #echo "VBoxManage controlvm $uuid savestate;"
  echo $line
  if [[ $line =~ \{(.*)\} ]]
  then
    vboxmanage controlvm ${BASH_REMATCH[1]} savestate
  fi
done
