process SORTMERNA {
    container='./sortMeRNA.sif'
     //Heavily inspired from nfcore modules
    tag "$name"
    label 'multiCpu'

    input:
    tuple val(name), path(reads)
    path fastas

    output: 
    tuple val(name), path("${name}_*.fq.gz")    , emit: reads

     """
        sortmerna \\
            ${'--ref '+fastas.join(' --ref ')} \\
            --reads ${reads[0]} \\
            --reads ${reads[1]} \\
            --threads $task.cpus \\
            --workdir . \\
            ${params.sortmerna_parameters}

        if [ ! -f non_rRNA_reads_fwd.fq.gz ]; then 
            gzip -c  non_rRNA_reads_fwd.fq > ${name}_1.fq.gz
        else 
            mv non_rRNA_reads_fwd.fq.gz ${name}_1.fq.gz
        fi
        if [ ! -f non_rRNA_reads_rev.fq.gz ]; then 
            gzip -c  non_rRNA_reads_rev.fq > ${name}_2.fq.gz
        else 
            mv non_rRNA_reads_rev.fq.gz ${name}_2.fq.gz
        fi
    """
}