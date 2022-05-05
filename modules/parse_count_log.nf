process PARSE_COUNT_LOG{

    input:
    tuple val(name), path(log)

    output:
    tuple val(name), path("${name}.log.csv"), emit: readcount

    script:
    """
    grep ":" ${log} | sed -e  "s/.*: \\([0-9]*\$\\)/\\1/g" | sed -z "s/\\n/;/g" > ${name}.log.csv
    """
}