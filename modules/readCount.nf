process READ_COUNT{
    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), val(stdout)    , emit: count

    script:
    """
    pigz -dc ${reads} | awk 'NR%4==2{c++} END { print "Test "c;}'
    """
}