process TRIM_GALORE {
    //Heavily inspired from nfcore modules
    //add tag
    //add label
    // modify cores
    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("*.fq.gz")    , emit: reads
    
    tuple val(name), path("*.html"), emit: html optional true
    tuple val(name), path("*.zip") , emit: zip optional true

    script:
    // Clipping presets have to be evaluated in the context of SE/PE
    def c_r1   = params.clip_r1 > 0             ? "--clip_r1 ${params.clip_r1}"                         : ''
    def c_r2   = params.clip_r2 > 0             ? "--clip_r2 ${params.clip_r2}"                         : ''
    def tpc_r1 = params.three_prime_clip_r1 > 0 ? "--three_prime_clip_r1 ${params.three_prime_clip_r1}" : ''
    def tpc_r2 = params.three_prime_clip_r2 > 0 ? "--three_prime_clip_r2 ${params.three_prime_clip_r2}" : ''
    
     """
        [ ! -f  ${name}_1.fastq.gz ] && ln -s ${reads[0]} ${name}_1.fastq.gz
        [ ! -f  ${name}_2.fastq.gz ] && ln -s ${reads[1]} ${name}_2.fastq.gz
        trim_galore \\
            ${params.trim_galore_options} \\
            --cores 4 \\
            $c_r1 \\
            $c_r2 \\
            $tpc_r1 \\
            $tpc_r2 \\
            --basename ${name} \\
            ${name}_1.fastq.gz \\
            ${name}_2.fastq.gz
    """
}