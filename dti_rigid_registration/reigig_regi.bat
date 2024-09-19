@echo off
setlocal

rem Set the base directory for your BIDS dataset
set BASE_DIR=C:\Users\sgeng\Desktop\DP-shuang\forkx\MDD_nii

rem Read subject IDs from the text file
for /f "delims=" %%S in (C:\Users\sgeng\Desktop\DP-shuang\code\list-mdd.txt) do (
    echo Processing sub-%%S...

    rem Step 1: Run bdp.exe for diffusion data
    "C:\Program Files\BrainSuite23a\bdp\bdp.exe" "%BASE_DIR%\sub-%%S\anat\sub-%%S_T1w.bfc.nii.gz" --nii "%BASE_DIR%\sub-%%S\dwi\sub-%%S_dwi.nii.gz" --bvec "%BASE_DIR%\sub-%%S\dwi\sub-%%S_dwi.bvec" --bval "%BASE_DIR%\sub-%%S\dwi\sub-%%S_dwi.bval" --t1-mask "%BASE_DIR%\sub-%%S\anat\sub-%%S_T1w.mask.nii.gz"

    echo Finished processing sub-%%S.
)

endlocal
