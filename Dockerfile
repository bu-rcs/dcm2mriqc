FROM nipreps/mriqc:latest

# install dcm2bids
RUN pip install dcm2bids

# install dcm2nii
RUN pip install dcm2niix

# create a new bids dir; create a bids scaffold
RUN mkdir /tmp/bids && dcm2bids_scaffold -o /tmp/bids && mkdir /tmp/derivatives && mkdir /tmp/work

# edit the participant tsv file
RUN sed -i '3d;4d' /tmp/bids/participants.tsv

# create a .bidsignore file
RUN echo "tmp_dcm2bids/" > /tmp/bids/.bidsignore

COPY --chmod=755 pipeline.sh /tmp/bids/code
COPY --chmod=755 download_bidsconfig.py /tmp/bids/code

WORKDIR /tmp/bids/code

ENTRYPOINT [ "pipeline.sh" ]

LABEL org.nrg.commands="[{\"name\": \"dcm2mriqc\", \"description\": \"A pipeline designed to run mriqc on DICOMs. Converts DICOMs to BIDS formatted NIFTIs files using dcm2bids, runs MRIQC, outputs MRIQC reports, then deletes intermediate NIFTI files.\", \"version\": \"latest\", \"schema-version\": \"1.0\", \"image\": \"kkurkela92/dcm2mriqc:latest\", \"type\": \"docker\", \"limit-cpu\": \"4\", \"command-line\": \"bash pipeline.sh '#MRIQC_ARGS#'\", \"reserve-memory\": \"10000\", \"override-entrypoint\": true, \"mounts\": [{\"name\": \"in\", \"writable\": false, \"path\": \"/input\"}, {\"name\": \"out\", \"writable\": true, \"path\": \"/output\"}], \"environment-variables\": {}, \"ports\": {}, \"inputs\": [{\"name\": \"mriqc-arguments\", \"description\": \"Arguments to pass to mriqc\", \"type\": \"string\", \"default-value\": \"\", \"required\": false, \"replacement-key\": \"#MRIQC_ARGS#\", \"select-values\": []}], \"outputs\": [{\"name\": \"output\", \"description\": \"Output QC files\", \"required\": true, \"mount\": \"out\"}], \"xnat\": [{\"name\": \"dcm2mriqc - scan\", \"description\": \"Run the dcm2mriqc with a scan mounted\", \"contexts\": [\"xnat:imageScanData\"], \"external-inputs\": [{\"name\": \"scan\", \"description\": \"Input scan\", \"type\": \"Scan\", \"required\": true, \"provides-files-for-command-mount\": \"in\", \"load-children\": false}], \"derived-inputs\": [], \"output-handlers\": [{\"name\": \"output-resource\", \"accepts-command-output\": \"output\", \"as-a-child-of\": \"scan\", \"type\": \"Resource\", \"label\": \"MRIQC\", \"tags\": []}]}], \"container-labels\": {}, \"generic-resources\": {}, \"ulimits\": {}, \"secrets\": []}]"
