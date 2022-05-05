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
    fname="${reads[0]}"
    if [ \${a##*.} = "gz" ]; then
        pigz -dc ${reads} | awk 'NR%4==1{c++} END { printf "%s", c;}'
    else
        cat ${reads} | awk 'NR%4==1{c++} END { printf "%s", c;}'
    fi
    """  
}