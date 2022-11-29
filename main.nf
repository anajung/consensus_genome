#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process consensus {
    conda 'bioconda::samtools ivar'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple path(bam), val(bamID)

    output:
    path '*'

    shell:
    '''
    F=$`basename !{bam} .lofreq.final.bam`

    samtools mpileup -A -d 0 -Q0 !{bam} | 
        ivar consensus -q 20 -t 0 -m 10 -n N -p "$F"
    '''

}

workflow {
    bam = channel.fromPath( params.bam ).map(bam -> [bam, bam.simpleName])
    consensus(bam)
}