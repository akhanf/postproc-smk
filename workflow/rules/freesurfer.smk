

rule freesurfer_subj:
    input:
        t1w = inputs.input_path['t1']
    params:
        subjects_dir = 'freesurfer',
        subj_sess = bids(**subj_wildcards,include_subject_dir=False,include_session_dir=False)
    output:
        subj_dir = directory(bids(root='freesurfer',include_subject_dir=False,include_session_dir=False,**subj_wildcards))
    threads: 8
    resources: 
        mem_mb=32000,
        time=1440
    shadow: 'minimal'
    container: config['singularity']['freesurfer']
    benchmark: 
        bids(root='benchmarks',suffix='freesurfer.txt',**subj_wildcards)
    log: 
        bids(root='logs',suffix='freesurfer.txt',**subj_wildcards)
    shell: 
        'recon-all -threads 8 -sd {resources.tmpdir} -i {input.t1w} '
        '-subjid {params.subj_sess} -parallel -hires -all -cw256 && '
        'cp -Rv {resources.tmpdir}/{params.subj_sess} {output}'
        


