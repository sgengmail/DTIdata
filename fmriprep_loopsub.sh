#!/bin/bash

# User inputs:
bids_root_dir=/Users/gengshuang/Desktop/depression/MDD_nii
bids_out_dir=/Users/gengshuang/Desktop/depression/derivatives/MDD
work_dir=/Users/gengshuang/Desktop/depression/code
nthreads=4
mem=20 #gb
container=docker #docker or singularity

# Convert virtual memory from gb to mb
mem=`echo "${mem//[!0-9]/}"` # remove 'gb' at end
mem_mb=$((mem*1000-5000)) # reduce some memory for buffer space during pre-processing

export FS_LICENSE=$bids_out_dir/license.txt


# Read subject IDs from lists.txt and process each subject
while IFS= read -r subject; do
  echo "Processing subject: $subject"
  
  # Run fMRIPrep
  if ! docker run --rm \
    -v "$FS_LICENSE:/Users/gengshuang/Desktop/depression/derivatives/MDD/license.txt:ro" \
    -v "$bids_root_dir:/data:ro" \
    -v "$bids_out_dir:/out" \
    -v "$work_dir:/scratch" \
    nipreps/fmriprep:24.0.1 /data /out participant \
    --participant-label "$subject" \
    -t restingsz \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file /Users/gengshuang/Desktop/depression/derivatives/MDD/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 MNI152NLin6Asym:res-2 \
    --nthreads "$nthreads" \
    --stop-on-first-crash \
    --mem_mb "$mem_mb" \
    --work-dir /scratch; then
    echo "Error processing subject: $subject. Skipping..."
  fi

done < lists.txt



