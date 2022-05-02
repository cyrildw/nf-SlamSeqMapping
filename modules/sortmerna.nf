process SORTMERNA {
     //Heavily inspired from nfcore modules
    //add tag
    //add label
    // modify threads
    input:
    tuple val(name), path(reads)

    output: 
    tuple val(name), path("*.fq.gz")    , emit: reads

     """
        sortmerna \\
            --ref ${params.sortmernaDB_ref.split(',').join(" --ref ")} \\
            --reads ${reads[0]} \\
            --reads ${reads[1]} \\
            --threads 6 \\
            --workdir . \\
            --aligned rRNA_reads \\
            --other non_rRNA_reads \\
            --paired_in \\
            --out2 

        mv non_rRNA_reads_fwd.fq.gz ${name}_1.fastq.gz
        mv non_rRNA_reads_rev.fq.gz ${name}_2.fastq.gz
    """
}