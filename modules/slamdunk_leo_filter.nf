process SLAMDUNK_LEO_FILTER {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu_short'
 

    input:
    tuple val(name), path(bams)

    output:
    tuple val(name), path("filter/${name}.sorted_filtered.bam*"), emit: alignment
    path "filter/${name}.sorted_filtered.log"                   , emit: log

    script:
    """
    slamdunk filter -o ./  -t $task.cpus ${params.slamdunk_parameters_filter} ${bams[0]}
    """
}