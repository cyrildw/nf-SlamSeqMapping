process SLAMDUNK_LEO_MAP {
    container='./SlamDunkLeo.simg'
    //add tag
    //add label
    // modify threads

    //Need to declare all created files ? like the ones for reference indexation ?
    input:
    tuple val(name), path(reads)
    path genome

    output: 
    tuple val(name), path("*.bam")   , emit:alignment
    //tuple val(name), path("${name}.bam")   , emit:alignment    
 //   path "${name}.log"                     , emit:log
//    path "*.sam"                            , emit: sam, optional: true
//    path "${genome}*"                       , emit:genome

    script:
    """
    slamdunk map \\
     -r ${genome} \\
     -o ./ \\
     ${params.slamdunk_parameters_map} \\
     -t 10 \\
     ${reads}

#    ln -s map/*bam ${name}.bam
#   ln -s map/*log ${name}.log
    
    """
}