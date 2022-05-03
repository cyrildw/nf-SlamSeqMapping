process SORTMERNA {
    container='./SlamDunkLeo.simg'
    //add tag
    //add label
    // modify threads

    //Need to declare all created files ? like the ones for reference indexation ?
    input:
    tuple val(name), path(reads)
    path genome

    output: 
    tuple val(name), path("${name}.bam*")

    script:
    """
    slamdunk map \\
     -r ${genome} \\
     -o ./tmp/ \\
     ${params.slamdunk.map_parameters} \\
     -t $task.cpus \\
     --paired \\
     ${reads}

    ln -s tmp/map/*bam ${name}.bam && samtools index ${name}.bam
    """
}