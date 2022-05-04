process SLAMDUNK_LEO_FILTER {
    container='./SlamDunkLeo.simg'
    //add tag
    //add label
    // modify threads

    input:
    tuple val(name), path(bams)

    output:
    tuple val(name), path("${name}.sorted_filtered.bam*"), emit: alignment
     path("${name}.sorted_filtered.log"), emit: log

    script:
    """
    slamdunk filter -o ./  -t 10 ${slamdunk_parameters_filter} ${bams[0]}
    """
}