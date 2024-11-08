# dcm2mriqc

Repository home of the dcm2mriqc docker container.

The container and pipeline are designed to build upon mriqc. The pipeline runs [dcm2bids](https://unfmontreal.github.io/Dcm2Bids/3.2.0/) on input dicom images and then runs the mriqc pipeline.

## Dependencies

1. mriqc [docker container](https://hub.docker.com/r/nipreps/mriqc); [documentation](https://mriqc.readthedocs.io/en/latest/)
2. dcm2bids -- [see external documentation](https://unfmontreal.github.io/Dcm2Bids/3.2.0/)
3. dcm2niix -- [see external documentation](https://github.com/rordenlab/dcm2niix)

## Key files

`pipeline.sh` -- a bash script that serves as a master script running the necessary steps to convert input DICOM files to NIFTI and the organizting the resulting NIFTI files into a temporary BIDS formatted directory for processing.
1. Step 1 -- 

