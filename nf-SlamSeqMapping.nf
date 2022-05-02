nextflow.enable.dsl = 2
i=0
Channel
      .fromPath(params.input_design)
      .splitCsv(header:true, sep:';')
      .map { row -> [ row.LibName, i++, file("$params.input_dir/$row.LibFastq1", checkIfExists: true), file("$params.input_dir/$row.LibFastq2", checkIfExists: true)]}
      .set { ch_design_reads_csv}

ch_design_reads_csv.view()

ch_design_reads_csv.map{ name, idx, fq1, fq2 -> [name, [fq1, fq2] ] }.set{ch_read_count}

ch_read_count.view()
