process READ_COUNT{
    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), val(stdout)    , emit: count

    script:
    """
    pigz -dc ${reads[0]} ${reads[1]} | awk 'NR%4==2{c++} END { print "Test "c;}'
    """
}