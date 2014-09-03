#bin/bash

suffixes=`ls | awk -F '-' '{print $2}'`

for suffix in $suffixes
  do mv option-$suffix label-$suffix
done

exit 0
