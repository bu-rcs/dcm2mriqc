#!/bin/bash

function cleanup {
  # cleanup the temp directory
  rm -Rf /tmp/bids
  rm -Rf /tmp/work
  rm -Rf /tmp/derivatives
}

# trap <function-to-run> <signal>
# 0 means 'all signals' like the one that is recieved when the script reaches its end.
# this should catch successful run throughs and crashes
trap cleanup 0

# step 1 -- pull down the config file
python download_bidsconfig.py --host $XNAT_HOST --user $XNAT_USER --password $XNAT_PASS

# step 2 -- BIDSIFY
dcm2bids -d /input/DICOM -p subject -c bids_config.json -o /tmp/bids

# step 3 -- run mriqc

# number of available cores
NCORES=`nproc --all`

# make a output subdirectory for one click downloading
mkdir /output/report

# mriqc call
mriqc /tmp/bids/ /output/report/ participant -w /tmp/work/ --no-sub --notrack --nprocs $NCORES --omp-nthreads $NCORES $1

# rename the report to make it clear what it is
mv /output/report/sub-subject*.html /output/report/mriqc_report.html
