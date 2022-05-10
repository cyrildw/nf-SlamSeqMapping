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
    def a   = params.maxpoly_a > 0              ? "-a ${params.maxpoly_a}"         : ''
    def trim5   = params.trim5 != null              ? "-5 ${params.trim5}"             : ''
    def mq   = params.mq > 0                    ? "-mq ${params.mq}"                :''
    def mi   = params.mi > 0                     ? "-mi ${params.mi}"               : ''
    def nm   = params.nm > 0                    ? "-nm ${params.nm}"                : ''
    def mc   = params.mc > 0                    ? "-mc ${params.mc}"                : ''
    def mv   = params.mv > 0                    ? "-mv ${params.mv}"                : ''
    def rl   = params.max_read_length > 0       ? "-rl ${params.max_read_length}"   : ''
    def mbq   = params.min_base_qual > 0        ? "-mbq ${params.min_base_qual}"    : ''
    
    
    """
    echo "slamdunk all -r ${genome} -o ./ -t $task.cpus ${params.slamdunk_parameters_all} \\
    $a $trim5 $mq $mi $nm $mc $mv $rl $mbq \\
    ${reads}"
    """
}