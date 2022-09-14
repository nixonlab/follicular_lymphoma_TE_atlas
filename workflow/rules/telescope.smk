#! /usr/bin/env python
# -*- coding utf-8 -*-

################################### TELESCOPE ###################################

rule telescope:
    conda: "../envs/telescope.yaml"
    output:
        "results/telescope/{samid}/{samid}-telescope_report.tsv"
    input:
        bam = "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.bam",
        annotation = rules.repeat_annotation_retro38.output[0]
    benchmark: "benchmarks/telescope/{samid}_telescope.tsv"
    log:
        "results/telescope/{samid}/telescope.log"
    threads: config['telescope_threads']
    params:
        outdir = "results/telescope/{samid}",
        exp_tag = "{samid}"
    shell:
        """
        telescope assign\
         --exp_tag {params.exp_tag}\
         --theta_prior 200000\
         --max_iter 200\
         --updated_sam\
         --outdir {params.outdir}\
         {input[0]}\
         {input[1]}\
         2>&1 | tee {log[0]}
        chmod 660 {output[0]}
        """

rule basic_complete:
    input:
        rules.telescope.output
    output:
        touch("results/completed/{samid}_completed.txt")
    params:
        star_out = "results/star_alignment/{samid}/",
        telescope_out = "results/telescope/{samid}/",
        dir_to_move_telescope = config['efs_dir_telescope'],  # "/efs/projects/HERV_CF_Dopkins/telescope/"
        dir_to_move_star = config['efs_dir_star'] # "/efs/projects/HERV_CF_Dopkins/star_algn/"
    shell:
        """
        mkdir -p {params.dir_to_move_telescope}
        mkdir -p {params.dir_to_move_star}
        cp -R {params.telescope_out} {params.dir_to_move_telescope}
        cp -R {params.star_out} {params.dir_to_move_star}
        rm -r {params.telescope_out}
        rm -r {params.star_out}
        """
