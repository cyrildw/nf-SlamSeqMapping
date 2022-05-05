process SLAMDUNK_BEDGRAPHTOBIGWIG{
    tag "$name"
    container=''
    input:
    tuple val(name), path(plusreads), path(plusreads_new), path(minreads), path(minreads_new), path(chr_size)

    output:
    tuple val(name), path("${name}_plus.bw"), path("${name}_plus_new.bw"), path("${name}_minus.bw"), path("${name}_minus_new.bw"), emit:bw

    script:
    """
    bedGraphToBigWig ${plusreads} ${chr_size} ${name}_plus.bw
    bedGraphToBigWig ${plusreads_new} ${chr_size} ${name}_plus_new.bw
    bedGraphToBigWig ${minreads} ${chr_size} ${name}_minus.bw
    bedGraphToBigWig ${minreads_new} ${chr_size} ${name}_minus_new.bw
    """
}