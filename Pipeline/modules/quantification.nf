process quantification {
    input:
    // We pass the reference FASTA alongside the reads for each sample run
    path reference_fasta
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}", emit: quant_dir

    script:
    """
    # 1. Build the index inside the temporary work directory
    salmon index -t ${reference_fasta} -i salmon_index --threads ${task.cpus}

    # 2. Run the quantification using the index we just built
    salmon quant \\
        -i salmon_index \\
        -l A \\
        -1 ${reads[0]} \\
        -2 ${reads[1]} \\
        -o ${sample_id} \\
        --threads ${task.cpus}
    """
}
