
def get_output_files_folders():
    """ This function is used to select what files to retain, since the 
    app is run on /tmp, and only files listed here will be copied over"""

    output_files_folders=[]
    output_files_folders.append(directory('hippunfold_{variant}_{version}/hippunfold/sub-{subject}'))
    if '--keep_work' in config['opts']['hippunfold'] or '--keep-work' in  config['opts']['hippunfold']:
        output_files_folders.append(directory('hippunfold_{variant}_{version}/work/sub-{subject}'))
    return output_files_folders

rule hippunfold:
    input:
        bids=os.path.join(config['bids_dir'],'sub-{subject}'),
    	container=lambda wildcards: config['singularity']['hippunfold'][wildcards.version]
    params:
        bids_dir=config['bids_dir'],
        tmp_out = '$SLURM_TMPDIR/hippunfold_{variant}_{version}',
        opts = config['opts']['hippunfold'],
        variant_opts=lambda wildcards: config['variant_opts']['hippunfold'][wildcards.variant],
        retain_outputs_from_tmp=lambda wildcards, resources, output: ' && '.join([f'cp -Rv $SLURM_TMPDIR/{out} {out}' for out in output])
    output:
        get_output_files_folders()
    shadow: 'minimal'
    threads: 8
    resources: 
        mem_mb=32000,
        time=180,
    shell: 
        'singularity exec -e {input.container} hippunfold {params.bids_dir} {params.tmp_out} participant --participant_label {wildcards.subject} '
        '--cores {threads}  {params.opts} {params.variant_opts} && '
        '{params.retain_outputs_from_tmp} '

def get_output_files_folders_hippb500():
    """ This function is used to select what files to retain, since the 
    app is run on /tmp, and only files listed here will be copied over"""

    output_files_folders=[]
    output_files_folders.append(directory('hippunfolddwi_{variant}_{version}/hippunfold/sub-{subject}'))
    if '--keep_work' in config['opts']['hippunfold'] or '--keep-work' in  config['opts']['hippunfold']:
        output_files_folders.append(directory('hippunfolddwi_{variant}_{version}/work/sub-{subject}'))
    return output_files_folders


rule hippunfold_hippb500:
    input:
        bids=os.path.join(config['bids_dir'],'sub-{subject}'),
        meanb500='snakedwi_b500/sub-{subject}/ses-001/dwi/sub-{subject}_ses-001_desc-eddy_b500.nii.gz',
    	container=lambda wildcards: config['singularity']['hippunfold'][wildcards.version]
    params:
        meanb500=lambda wildcards: 'snakedwi_b500/sub-{subject}/ses-001/dwi/sub-{subject}_ses-001_desc-eddy_b500.nii.gz',
        bids_dir=config['bids_dir'],
        tmp_out = '$SLURM_TMPDIR/hippunfolddwi_{variant}_{version}',
        opts = config['opts']['hippunfold'],
        variant_opts=lambda wildcards: config['variant_opts']['hippunfolddwi'][wildcards.variant],
        retain_outputs_from_tmp=lambda wildcards, resources, output: ' && '.join([f'cp -Rv $SLURM_TMPDIR/{out} {out}' for out in output])
    output:
        get_output_files_folders_hippb500()
    shadow: 'minimal'
    threads: 8
    resources: 
        mem_mb=32000,
        time=180,
    shell: 
        'singularity exec -e {input.container} hippunfold {params.bids_dir} {params.tmp_out} participant --participant_label {wildcards.subject} '
        '--cores {threads}  {params.opts} {params.variant_opts} '
        '--path-hippb500 {params.meanb500} && '
        '{params.retain_outputs_from_tmp} '

