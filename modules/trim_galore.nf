process TRIM_GALORE {
    //add tag
    //add label
    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("name.*.trimed.fq.gz")    , emit: reads
    
    tuple val(meta), path("*.html"), emit: html optional true
    tuple val(meta), path("*.zip") , emit: zip optional true

    