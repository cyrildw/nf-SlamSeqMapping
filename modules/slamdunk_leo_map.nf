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
    tuple val(name), path("${name}.bam*")   , emit: alignment
    path "${name}.log"                     , emit: log
    path "*.sam"                            , emits: sam, optional: true
    path "${genome}*"                       , emit: genome

    script:
    """
    slamdunk map \\
     -r ${genome} \\
     -o ./ \\
     ${params.slamdunk_map_parameters} \\
     -t 10 \\
     ${reads}

    ln -s map/*bam ${name}.bam && samtools index ${name}.bam
    """
}