process PARSE_COUNT_LOG{

    input:
    tuple val(name), path(log)

    output:
    tuple val(name), val(totalreads), val(plusreads), val(plusreads_new), emit: readcount

    script:
    totalreads=""
    plusreads=""
    plusreads_new=""
    minreads=""
    minreads_new=""
    """
    grep ":" ${log} | sed -e  "s/.*: \\([0-9]*\$\\)/\\1/g" > parsedLog
    totalreads=`sed '1q;d' parsedLog`
    plusreads=`sed '2q;d' parsedLog`
    plusreads_new=`sed '3q;d' parsedLog`
    minreads=`sed '4q;d' parsedLog`
    minreads_new=`sed '5q;d' parsedLog`
    """
}