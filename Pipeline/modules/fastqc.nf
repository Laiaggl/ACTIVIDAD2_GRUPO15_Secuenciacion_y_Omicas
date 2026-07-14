process fastqc {
    input:
    tuple val(sample_id), path(reads)

    output:
    path "*.{html,zip}", emit: reports

    script:
    """
    fastqc --threads ${task.cpus} ${reads}
    """
}
