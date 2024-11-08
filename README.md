# dcm2mriqc

Repository home of the dcm2mriqc docker container.

The container and pipeline are designed to build upon mriqc. The pipeline runs [dcm2bids](https://unfmontreal.github.io/Dcm2Bids/3.2.0/) on input dicom images and then runs the mriqc pipeline.

## Dependencies

1. mriqc [docker container](https://hub.docker.com/r/nipreps/mriqc); [documentation](https://mriqc.readthedocs.io/en/latest/)
2. dcm2bids -- [see external documentation](https://unfmontreal.github.io/Dcm2Bids/3.2.0/)
3. dcm2niix -- [see external documentation](https://github.com/rordenlab/dcm2niix)

## Key files

`pipeline.sh` -- a bash script that serves as a master script running the necessary steps to convert input DICOM files to NIFTI and the organizting the resulting NIFTI files into a temporary BIDS formatted directory for processing.
1. Step 1 -- download the bids_config.json file from XNAT. The bids_config.json file is uploaded to your XNAT instance using [Legacy XNAT Site Configuration API](https://wiki.xnat.org/xnat-api/legacy-xnat-site-configuration-api). An example GET and PUT command using curl are as follows: `curl --location-trusted -u USERNAME --file-upload BIDS_CONFIG.JSON -X PUT YOURXNAT/data/config/bids/bidsmap?json=TRUE` to place your bids_config.json file to the XNAT server and `curl --location-trusted -u USERNAME -X GET YOURXAT/data/config/bids/bidsmap` to pull the current bids_config.json file from the server. See "How do I create a bids_config.json" for more information on how to create one of these files for your purposes.
2. Step 2 -- in a single step, use dcm2bids to a.) turn this scan's DICOMs into NIFTIs b.) give these NIFTIs a BIDS compliant file name, c.) place the NIFTI file within a BIDS compliant directory structure, d.) create BIDS compliant json sidecars for the scans. For more detailed information, reading the external BIDS documentation is highly recommended. The BIDS compliant data structure is written to /tmp/bids within the container. 

