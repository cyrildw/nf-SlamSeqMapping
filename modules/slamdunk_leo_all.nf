process SLAMDUNK_LEO_ALL {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu'
    
    //Need to declare all created files ? like the ones for reference indexation ?
    input:
    tuple val(name), path(reads), path(genome)
// path genome

    output:
    tuple val(name), path("map/*.bam")                   , emit:map_alignment
    tuple val(name), path("map/*log")                    , emit:map_log


    tuple val(name), path("filter/*filtered.bam")       , emit: filter_alignment
    tuple val(name), path("filter/*log")                , emit: filter_log

    tuple val(name), path("snp/*vcf")                   , emit: snp_vcf
    tuple val(name), path("snp/*log")                   , emit: snp_log

    tuple val(name), path("count/*mins.bedgraph"), 
                    path("count/*mins_new.bedgraph"), 
                    path("count/*plus.bedgraph"), 
                    path("count/*plus_new.bedgraph")    , emit:count_alignment
    tuple val(name), path("count/*log")                 , emit:count_log


    script:
    """
    slamdunk all -r ${genome} -o ./ -t $task.cpus ${params.slamdunk_parameters_all} \\
    -a ${params.maxpoly_a} \\
    -5 ${params.trim5} \\
    -mq ${params.mq} \\
    -mi ${params.mi} \\
    -nm ${params.nm} \\
    -mc ${params.mc} \\
    -mv ${params.mv} \\
    -rl ${params.max_read_length} \\
    -mbq ${params.min_base_qual} \\
    ${reads}
    """
}