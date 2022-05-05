 process SLAMDUNK_LEO_COUNT {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu'


    input:
    tuple val(name), path(bams), path(vcf), path(genome)

    output:
    tuple val(name), path("count/${name}.sorted_filtered_tcount_mins.bedgraph"), path("count/${name}.sorted_filtered_tcount_mins_new.bedgraph"), path("count/${name}.sorted_filtered_tcount_plus.bedgraph"), path("count/${name}.sorted_filtered_tcount_plus_new.bedgraph"), emit: alignment
    tuple val(name), path("count/*log")                  , emit: log

    script:
    """
    slamdunk count -o ./ -s ./ -r ${genome} -t $task.cpus ${params.slamdunk_parameters_count} ${bams[0]}
    """
 }