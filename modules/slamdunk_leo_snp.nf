process SLAMDUNK_LEO_SNP {
    container='./SlamDunkLeo.simg'
    tag "$name"
    label 'multiCpu_short'

    input:
    tuple val(name), path(bams), path(genome)

    output:
    tuple val(name), path("snp/*vcf"), emit: vcf
    path "snp/*log"                 , emit: log

    script:
    """
    slamdunk snp -r ${genome} -o ./ ${params.slamdunk_parameters_snp} -t $task.cpus ${bams[0]}
    """
}