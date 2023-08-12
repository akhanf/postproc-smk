# postproc-smk

WIP workflow to automate running bids apps (e.g. hippunfold, snakedwi) with different options (variants) or versions.

Apps use `$SLURM_TMPDIR` as temporary output, copying results afterwards. 

Set inputs, options, app versions etc in config.

Snakedwi is not fully integrated yet (e.g. you need to git clone snakedwi into `snakedwi_src` currently)..


