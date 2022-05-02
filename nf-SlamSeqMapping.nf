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

workflow {

//Initial file processing
ch_design_reads_csv
    .map{ name, idx, fq1, fq2 -> [name, [fq1, fq2] ] }
    .set{ch_fastq_reads}

//Counting sequencing reads
ch_nbseq_reads = READ_COUNT_INIT( ch_fastq_reads ).count

//Filtering against ribosomal RNA
ch_rRNA_fastas= Channel.from($params.sortmernaDB_ref.split(',')).map{ it -> file(it)}.view()

/*ch_filtered_reads = SORTMERNA( ch_fastq_reads).reads
ch_nbfiltered_reads= READ_COUNT_FILTERED(ch_filtered_reads).count

ch_trimed_reads= TRIM_GALORE( ch_filtered_reads).reads
ch_nbtrimed_reads= READ_COUNT_TRIMED(ch_trimed_reads).count
//ch_read_count.view()



ch_design_reads_csv
    .join( ch_nbseq_reads )
    .join( ch_nbfiltered_reads)
    .join( ch_nbtrimed_reads)
    .view()
*/
}