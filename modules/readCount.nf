process READ_COUNT{
    tag "$name"
    label 'local'
    cache false

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), stdout     , emit: count

    script:
    """
    if [ "${reads[0]}" == "*.gz" ]; then
        pigz -dc ${reads} | awk 'NR%4==2{c++} END { printf "%s", c;}'
    else
        cat ${reads} | awk 'NR%4==2{c++} END { printf "%s", c;}'
    fi
    """  
    }
}