process SLAMDUNK_LEO_SNP {
    container='./SlamDunkLeo.simg'
    //add tag
    //add label
    // modify threads


    input:
    tuple val(name), path(bams)
    path(genome)

    output:
    tuple val(name), path("*vcf"), emit: vcf
    path "*log"                 , emit: log

    script:
    """
    slamdunk snp -r ${genome} -o ./ ${params.slamdunk_parameters_snp} -t 10 ${bams[0]}
    """
}