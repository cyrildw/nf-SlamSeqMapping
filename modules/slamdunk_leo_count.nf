 process SLAMDUNK_LEO_COUNT {
    container='./SlamDunkLeo.simg'
    //add tag
    //add label
    // modify threads

    input:
    tuple val(name), path(bams), path(vcf)
    path(genome)

    output:
    tuple val(name), path("${name}.sorted_filtered.bam*"), emit: alignment
    path("${name}.sorted_filtered.log"), emit: log

    script:
    """
    slamdunk count -o ./ -s ./ -r SacCer3.fa -t 10 ${slamdunk_parameters_count} ${bams[0]}
    """
 }