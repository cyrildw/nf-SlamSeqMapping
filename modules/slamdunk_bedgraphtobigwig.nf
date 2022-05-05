process SLAMDUNK_BEDGRAPHTOBIGWIG{
    tag "$name"
    container=''
    input:
    tuple val(name), path(minreads), path(mineads_new), path(plusreads), path(plsreads_new), path(chr_size)

    output:
    tuple val(name), path("${name}_minus.bw"), path("${name}_minus_new.bw"), path("${name}_plus.bw"), path("${name}_plus_new.bw"), emit:bw

    script:
    """
    sort -k1,1 -k2,2n ${minreads} > tmp.sorted.bg && bedGraphToBigWig tmp.sorted.bg ${chr_size} ${name}_minus.bw
    sort -k1,1 -k2,2n ${minreads_new} > tmp.sorted.bg && bedGraphToBigWig tmp.sorted.bg ${chr_size} ${name}_minus_new.bw
    sort -k1,1 -k2,2n ${plusreads} > tmp.sorted.bg && bedGraphToBigWig tmp.sorted.bg ${chr_size} ${name}_plus.bw
    sort -k1,1 -k2,2n ${plusreads_new} > tmp.sorted.bg && bedGraphToBigWig tmp.sorted.bg ${chr_size} ${name}_plus_new.bw
    """
}