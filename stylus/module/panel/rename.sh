#bin/bash

suffixes=`ls | awk -F '-' '{print $2}'`

for suffix in $suffixes
  do mv tab-$suffix panel-$suffix
done

exit 0
