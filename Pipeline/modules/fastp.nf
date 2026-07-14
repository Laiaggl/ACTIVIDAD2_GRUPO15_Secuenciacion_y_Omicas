process fastp {
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*_filtered.fastq.gz"), emit: trimmed_reads
    path "*.json", emit: json_report
    path "*.html", emit: html_report

    script:
    """
    fastp \\
        --in1 ${reads[0]} \\
        --in2 ${reads[1]} \\
        --out1 ${sample_id}_R1_filtered.fastq.gz \\
        --out2 ${sample_id}_R2_filtered.fastq.gz \\
        --detect_adapter_for_pe \\
        --cut_front \\
        --cut_tail \\
        --cut_window_size 12 \\
        --cut_mean_quality 30 \\
        --length_required 35 \\
        --json ${sample_id}.json \\
        --html ${sample_id}.html \\
        --thread ${task.cpus}
    """
}
