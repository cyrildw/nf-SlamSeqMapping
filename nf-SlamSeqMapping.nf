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
include { READ_COUNT as READ_COUNT_INIT     } from './modules/readCount'
include { READ_COUNT as READ_COUNT_FILTERED } from './modules/readCount'
include { READ_COUNT as READ_COUNT_TRIMED   } from './modules/readCount'
include { SORTMERNA                         } from './modules/sortmerna'
include { TRIM_GALORE                       } from './modules/trim_galore'
include { SAMTOOLS_SORT_INDEX               } from './modules/samtools_sort_index'
include { SLAMDUNK_LEO_ALL                  } from './modules/slamdunk_leo_all'
include { SLAMDUNK_LEO_MAP                  } from './modules/slamdunk_leo_map'
include { SLAMDUNK_LEO_FILTER               } from './modules/slamdunk_leo_filter'
include { SLAMDUNK_LEO_SNP                  } from './modules/slamdunk_leo_snp'
include { SLAMDUNK_LEO_COUNT                } from './modules/slamdunk_leo_count'
include { PARSE_COUNT_LOG                   } from './modules/parse_count_log'
include { SLAMDUNK_BEDGRAPHTOBIGWIG         } from './modules/slamdunk_bedgraphtobigwig'
include { CSV_REPORT as CSV_REPORT_STATS    } from './modules/csv_report'

workflow {


//Initial file processing
ch_design_reads_csv
    .map{ name, idx, fq1, fq2 -> [name, [fq1, fq2] ] }
    .set{ch_fastq_reads}
//importing reference genome & combining in a channel
ch_reference_genome=Channel.fromPath("$params.input_dir/$params.reference_genome")
//bedGraphToBigWig
ch_chr_size=Channel.fromPath("$params.input_dir/$params.chr_size")




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


ch_trimed_reads.combine(ch_reference_genome).set{ch_reads_to_map}

//
// SlamDunk from Leo
//
if(params.slamdunk_individual_dunks){
    //  map
    ch_slam_mapped = SLAMDUNK_LEO_MAP(ch_reads_to_map).alignment

    //sort and index bam File
    ch_slam_sorted = SAMTOOLS_SORT_INDEX(ch_slam_mapped).alignment

    //filter
    ch_slam_filtered = SLAMDUNK_LEO_FILTER( ch_slam_sorted).alignment

    //snp
    ch_slam_filtered.combine(ch_reference_genome).set{ch_to_snp}
    ch_slam_snp = SLAMDUNK_LEO_SNP( ch_to_snp ).vcf

    //count
    ch_slam_filtered
        .join( ch_slam_snp )
        .combine(ch_reference_genome)
        .set{ ch_for_count }

    ch_slam_count = SLAMDUNK_LEO_COUNT( ch_for_count )
    ch_slam_count.alignment 
        .combine(ch_chr_size)
        .set{ch_to_bw}

    //Parse Slamdunk Log
    ch_count_log = PARSE_COUNT_LOG( ch_slam_count.log ).readcount
    
    //ch_neo_counts.view().map{ it -> [it[0], it[1].collect() ]}.view()
}
else{
    ch_slam_all = SLAMDUNK_LEO_ALL(ch_reads_to_map)
    ch_count_log = PARSE_COUNT_LOG( ch_slam_all.count_log ).readcount
    
    ch_slam_all.count_alignment 
        .combine(ch_chr_size)
        .set{ch_to_bw}
}
ch_count_log.map{ name, csv -> [name, csv.readLines()[0].split(";")]}.set{ch_neo_counts} // form of [Name, [totalreads, plusreads, plusreads_new, minusreads, minusreads_new]]

ch_bw = SLAMDUNK_BEDGRAPHTOBIGWIG(ch_to_bw).bw
ch_bw.view()

//Merging info.
ch_design_reads_csv
    .join( ch_nbseq_reads )
    .join( ch_nbfiltered_reads)
    .join( ch_nbtrimed_reads)
    .join( ch_neo_counts)
    .map{ name, idx, read1, read2, nbSeqreads, nbFilteredreads, nbTrimreads, mapstats -> [idx, name,nbSeqreads, nbFilteredreads, nbTrimreads, mapstats[0], mapstats[1], mapstats[2], mapstats[3], mapstats[4] ] }
    .map{ it->[it.join("\t")]}.collect()
    .set{ ch_summary}
ch_summary.view()

ch_stats_header = channel
    .fromList(["Report.csv", "LibName;Nb_sequenced_read;Nb_Filtered_reads;Nb_trimmed_reads;Nb_mapped_reads;Nb_plus_reads;Nb_plus_reads_new;Nb_minus_reads;Nb_minus_reads_new"])
    .collect()

ch_last=CSV_REPORT_STATS(ch_stats_header, ch_summary)

}