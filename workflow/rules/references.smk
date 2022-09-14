#! /usr/bin/env python
# -*- coding: utf-8 -*-

################################# DOWNLOAD REFS #################################

rule download_remote:
    """ Downloads a remote file and checks the md5sum.
        Filenames, URLs and md5 checksums are configured in the `remotefiles` element of
        the configfile
    """
    output:
        'databases/remotefiles/{f}'
    params:
        url = lambda wildcards: config['downloads'][wildcards.f]['url'],
        md5 = lambda wildcards: config['downloads'][wildcards.f]['md5']
    shell:
        '''
curl -L {params.url} > {output[0]}
echo {params.md5}  {output[0]} | md5sum -c -
        '''

################################# EXTRACT REFS #################################

rule extract_genome:
    input:
        'databases/remotefiles/GRCh38.d1.vd1.fa.tar.gz'
    output:
        config['sequences']['genome'],
        config['sequences']['genome_idx'],
        config['sequences']['genome_dict']
    conda:
        "../envs/utils.yaml"
    shell:
        '''
mkdir -p $(dirname {output[0]})
tar -Oxzf {input} | bgzip > {output[0]}
samtools faidx {output[0]}
picard CreateSequenceDictionary R={output[0]} O={output[2]}
        '''

rule extract_gtf_gz:
    input:
        'databases/remotefiles/{f}.gtf.gz'
    output:
        'databases/annotations/{f}.gtf'
    shell:
        '''
echo {resources.tmpdir}
gunzip -c {input} > {output}
        '''

############################# TELESCOPE ANNOTATION #############################

rule repeat_annotation_retro38:
    input:
        'databases/remotefiles/retro.hg38.v1.gtf',
        'databases/remotefiles/retro.hg38.v1.tsv.gz'
    output:
        'databases/annotations/retro.hg38.v1.gtf',
        'databases/annotations/retro.hg38.v1.tsv.gz'
    shell:
        '''
cp {input[0]} {output[0]}
cp {input[1]} {output[1]}
        '''
