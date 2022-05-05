 process SLAMDUNK_LEO_COUNT {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu_short'


    input:
    tuple val(name), path(bams), path(vcf), path(genome)

    output:
    tuple val(name), path("count/${name}.sorted_filtered.bam"), emit: alignment
    path "count/${name}.sorted_filtered.log"                   , emit: log

    script:
    """
    slamdunk count -o ./ -s ./ -r ${genome} -t $task.cpus ${params.slamdunk_parameters_count} ${bams[0]}
    """
 }