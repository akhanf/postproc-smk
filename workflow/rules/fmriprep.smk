
rule fmriprep_subj:
    input:
        bids=config['bids_dir'],
        t1w = inputs.input_path['t1'],
        freesurfer = bids(root='freesurfer',include_subject_dir=False,include_session_dir=False,**subj_wildcards)
    params:
        fs_subjects_dir='freesurfer',
        fs_license_file=config['fs_license_file'],
        subj_sess = bids(**subj_wildcards,include_subject_dir=False,include_session_dir=False)
    output:
        subj_dir = directory(bids(root='fmriprep',include_subject_dir=False,include_session_dir=False,**subj_wildcards)),
        subj_html = bids(root='fmriprep',include_subject_dir=False,include_session_dir=False,subject='{subject}') + '.html',
        dd='fmriprep-extra/sub-{subject}_dataset_description.json'
    container: config['singularity']['fmriprep']
    shadow: 'minimal'
    benchmark: 
        bids(root='benchmarks',suffix='fmriprep.txt',**subj_wildcards)
    log: 
        bids(root='logs',suffix='fmriprep.txt',**subj_wildcards)
    threads: 8
    resources: 
        mem_mb=32000,
        time=360
    shell: 
        'fmriprep {input.bids} fmriprep participant --participant_label {wildcards.subject} '
        '--nthreads {threads} --n_cpus {threads} --mem_mb {resources.mem_mb} --omp-nthreads {threads} '
        '--fs-license-file {params.fs_license_file} --fs-subjects-dir {params.fs_subjects_dir} --cifti-output 91k '
        '--notrack --output-layout bids --use-aroma '
        '--output-spaces T1w MNI152NLin2009cAsym MNI152NLin6Asym && '  
        'cp -v fmriprep/dataset_description.json {output.dd} '

"""
rule fmriprep_extra:
    input:
        dd=expand(rules.fmriprep_subj.output.dd,subject=subjects)
    output:
        dd='fmriprep/dataset_description.json'
    shell:
        'cp {input[0]} {output}'

 """
