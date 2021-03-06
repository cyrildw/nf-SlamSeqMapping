process SLAMDUNK_LEO_MAP {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu'
    
    //Need to declare all created files ? like the ones for reference indexation ?
    input:
    tuple val(name), path(reads), path(genome)
// path genome

    output: 
    tuple val(name), path("map/*.bam")   , emit:alignment
    //tuple val(name), path("${name}.bam")   , emit:alignment    
    path "map/*log"                     , emit:log
//    path "*.sam"                            , emit: sam, optional: true
//    path "${genome}*"                       , emit:genome

    script:
    """
    slamdunk map \\
     -r ${genome} \\
     -o ./ \\
     ${params.slamdunk_parameters_map} \\
     -t $task.cpus \\
     ${reads}

    """
}