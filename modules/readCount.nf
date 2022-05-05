process READ_COUNT{
    tag "$name"
    label 'local'
    cache false

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), stdout     , emit: count

    script:
    if(reads.matches("gz")){
    """
    pigz -dc ${reads} | awk 'NR%4==2{c++} END { printf "%s", c;}'
    """
    }
    else{
    """
    cat ${reads} | awk 'NR%4==2{c++} END { printf "%s", c;}'
    """  
    }
}