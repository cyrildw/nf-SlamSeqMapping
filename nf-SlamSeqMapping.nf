nextflow.enable.dsl = 2
i=0
Channel
      .fromPath(params.input_design)
      .splitCsv(header:true, sep:';')
      .map { row -> [ row.LibName, i++, file("$params.input_dir/$row.LibFastq1", checkIfExists: true), file("$params.input_dir/$row.LibFastq2", checkIfExists: true)]}
      .set { ch_design_reads_csv}

//ch_design_reads_csv.view()


//
// MODULE LOAD
//
include { READ_COUNT as READ_COUNT_INIT                 } from './modules/readCount'
include { READ_COUNT as READ_COUNT_FILTERED                 } from './modules/readCount'
include { READ_COUNT as READ_COUNT_TRIMED                 } from './modules/readCount'
include { SORTMERNA                                      } from './modules/sortmerna'
include { TRIM_GALORE                                    } from './modules/trim_galore'
include { SAMTOOLS_SORT_INDEX                                    } from './modules/samtools_sort_index'
include { SLAMDUNK_LEO_MAP                                    } from './modules/slamdunk_leo_map'
include { SLAMDUNK_LEO_FILTER                                    } from './modules/slamdunk_leo_filter'
include { SLAMDUNK_LEO_SNP                                    } from './modules/slamdunk_leo_snp'
include { SLAMDUNK_LEO_COUNT                                    } from './modules/slamdunk_leo_count'

workflow {

//Initial file processing
ch_design_reads_csv
    .map{ name, idx, fq1, fq2 -> [name, [fq1, fq2] ] }
    .set{ch_fastq_reads}

//Counting sequencing reads
ch_nbseq_reads = READ_COUNT_INIT( ch_fastq_reads ).count

//Filtering against ribosomal RNA
if(!params.skip_rRNA_filtering){
    ch_rRNA_fastas= Channel.from(params.sortmernaDB_ref.split(',')).map{ it -> file(it)}.collect()
    ch_filtered_reads = SORTMERNA( ch_fastq_reads,ch_rRNA_fastas).reads
    ch_nbfiltered_reads= READ_COUNT_FILTERED(ch_filtered_reads).count
}
else{
    ch_filtered_reads = ch_fastq_reads
    ch_nbfiltered_reads = ch_nbseq_reads
}

//Triming the reads
if(!params.skip_triming){
    ch_trimed_reads= TRIM_GALORE( ch_filtered_reads).reads
    ch_nbtrimed_reads= READ_COUNT_TRIMED(ch_trimed_reads).count
}
else{
    ch_trimed_reads = ch_filtered_reads
    ch_nbtrimed_reads = ch_nbfiltered_reads
}


//
// SlamDunk from Leo
//
//map
ch_reference_genome=Channel.fromPath("$params.input_dir/$params.reference_genome")
ch_trimed_reads.combine(ch_reference_genome).view()
ch_slam_mapped = SLAMDUNK_LEO_MAP(ch_trimed_reads).alignment

//sort and index bam File
ch_slam_sorted = SAMTOOLS_SORT_INDEX(ch_slam_mapped).alignment

//filter
ch_slam_filtered = SLAMDUNK_LEO_FILTER( ch_slam_sorted).alignment

//snp
ch_slam_snp = SLAMDUNK_LEO_SNP( ch_slam_filtered, ch_reference_genome ).vcf

//count
ch_slam_filtered
    .join( ch_slam_snp ).view()
//    .set( ch_slam_for_count )

//ch_slam_count = SLAMDUNK_LEO_COUNT ( ch_slam_filtered )


//Merging info.
ch_design_reads_csv
    .join( ch_nbseq_reads )
    .join( ch_nbfiltered_reads)
    .join( ch_nbtrimed_reads)
    .view()

}