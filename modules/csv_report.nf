process CSV_REPORT{
    tag "$name"
    label 'noContainer'
    //cache false

    input:
    tuple val(filename), val(header)
    val(data)

    output:
    path(filename)

    script:
    """
    echo "${header}" > ${filename}
    echo "${data.join('\n')}" | sort -k1 -n | awk '{for(i=2;i<=NF;i++) printf \$i";"; print ""}' >> ${filename}
    """  
