process READ_COUNT{
    tag "$name"
    label 'local'
    container=''

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), stdout     , emit: count

    script:
    """
    pigz -dc ${reads} | awk 'NR%4==2{c++} END { printf "%s", c;}'
    """
}