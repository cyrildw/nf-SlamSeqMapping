process SORTMERNA {
    container='./sortMeRNA.sif'
     //Heavily inspired from nfcore modules
    //add tag
    //add label
    // modify threads
    input:
    tuple val(name), path(reads)
    path fastas

    output: 
    tuple val(name), path("*.fq.gz")    , emit: reads

     """
        sortmerna \\
            ${'--ref '+fastas.join(' --ref ')} \\
            --reads ${reads[0]} \\
            --reads ${reads[1]} \\
            --threads 6 \\
            --workdir . \\
            --fastx \\
            --aligned rRNA_reads \\
            --other non_rRNA_reads \\
            --paired_in \\
            --out2 

        mv non_rRNA_reads_fwd.fq.gz ${name}_1.fq.gz
        mv non_rRNA_reads_rev.fq.gz ${name}_2.fq.gz
    """
}