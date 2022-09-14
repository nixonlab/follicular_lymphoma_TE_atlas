#! /usr/bin/env python
# -*- coding: utf-8 -*-
rule samtools_bam_cram:
    input:
        bam = "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.bam",
        ref = config['sequences']['genome']
    output:
        "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.cram",
    conda:
        "../envs/utils.yaml"
    threads: 2
    shell:
        '''
samtools view -C -T {input.ref} {input.bam} > {output[0]}
        '''

rule samtools_sort_cram:
    input:
        bam = "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.bam",
        ref = config['genome_fasta']
    output:
        "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.cram",
        "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.cram.crai"
    conda:
        "../envs/utils.yaml"
    threads: 8
    shell:
        '''
tdir=$(mktemp -d {config[tmpdir]}/{rule}.{wildcards.sample_id}.XXXXXX)
samtools sort -u -@ {threads} -T $tdir {input.bam} | samtools view -C -T {input.ref} > {output[0]}
samtools index {output[0]}
        '''

rule stringtie:
    input:
        bam = "results/star_alignment/{samid}/{samid}_GDC38.Aligned.out.cram",
        # does stringie require a coordinated sorted bam?
        ref = config['sequences']['genome'],
        annot = config['annotations']['gencode']
    output:
        "results/stringtie/{samid}/{samid}_transcripts.gtf"
    conda:
        "../envs/stringtie.yaml"
    threads: 2
    shell:
        '''
stringtie\
 -p {threads}\
 -u \
 -c 2.5\
 -s 2.5\
 -j 2\
 -f 0.05\
 -M 1\
 -G {input.annot}\
 --cram-ref {input.ref}\
 -o {output[0]}\
 {input.cram}
        '''
