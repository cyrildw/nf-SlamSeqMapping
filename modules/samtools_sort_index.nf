process SAMTOOLS_SORT_INDEX{
    container='./SlamDunkLeo.simg'
    
    input:
    tuple val(name), path(bamfile)

    output:
    tuple val(name), path("${name}.sorted.bam*"), emits: aligment

    script:
    """
    samtools view -@ $task.cpus -f 2 -b -o ${name}.bam ${bamfile}
    samtools sort -@ $task.cpus -o ${name}.sorted.bam ${name}.bam
    samtools index ${name}.sorted.bam
    """
}