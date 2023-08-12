
def get_output_files_folders():
    """ This function is used to select what files to retain, since the 
    app is run on /tmp, and only files listed here will be copied over"""

    output_files_folders=[]
    output_files_folders.append(directory('snakedwi/sub-{subject}'))
    output_files_folders.append(directory('work/sub-{subject}'))
    return output_files_folders

rule snakedwi:
    input:
        bids=os.path.join(config['bids_dir'],'sub-{subject}'),
    	snakedwi='snakedwi_src'
    params:
        bids_dir=config['bids_dir'],
        tmp_out = '$SLURM_TMPDIR',
        snakedwi_opts=lambda wildcards: config['opts']['snakedwi'],
        retain_outputs_from_tmp=lambda wildcards, resources, output: ' && '.join([f'cp -Rv $SLURM_TMPDIR/{out} {out}' for out in output])
    output:
        get_output_files_folders()
    shadow: 'minimal'
    threads: 8
    resources: 
        mem_mb=32000,
        time=360,
        gpus=1
    shell: 
        '{input.snakedwi}/snakedwi/run.py {params.bids_dir} {params.tmp_out} participant --participant_label {wildcards.subject} '
        '--cores {threads}  {params.snakedwi_opts} && '
        '{params.retain_outputs_from_tmp} '

