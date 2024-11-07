#!/bin/bash

# step 1 -- pull down the config file
python download_bidsconfig.py --host $XNAT_HOST --user $XNAT_USER --password $XNAT_PASS

# step 2 -- BIDSIFY
dcm2bids -d /input/DICOM -p 01 -c bids_config.json -o /tmp/bids

# step 3 -- run mriqc
NCORES=`nproc --all`
mriqc /tmp/bids/ /tmp/derivatives/ participant -w /tmp/work/ --no-sub --notrack --nprocs $NCORES --omp-nthreads $NCORES

# step 6 -- place mriqc output to XNAT
mv /tmp/derivatives/sub-01*.html /output/mriqc_report.html
mv /tmp/derivatives/sub-01/* /output/

# step 7 -- cleanup
rm -Rf /tmp/bids
rm -Rf /tmp/derivatives
rm -Rf /tmp/work