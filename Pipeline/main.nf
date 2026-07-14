include { fastp } from './modules/fastp.nf'
include { fastqc } from './modules/fastqc.nf'
include { multiqc } from './modules/multiqc.nf'
include { quantification } from './modules/quantification.nf'

workflow {
    reads_ch = channel.fromFilePairs(params.reads, checkIfExists: true)
    ref_ch = file(params.reference, checkIfExists: true)

    fastp(reads_ch)
    fastqc(fastp.out.trimmed_reads)

    multiqc_inputs = fastp.out.json_report
        .mix(fastp.out.html_report, fastqc.out.reports)
        .collect()

    multiqc(multiqc_inputs)

    quantification(ref_ch, fastp.out.trimmed_reads)
}
