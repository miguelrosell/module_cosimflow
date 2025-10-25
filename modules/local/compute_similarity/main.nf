nextflow.enable.dsl=2

process COMPUTE_SIMILARITY_PROCESS {
    tag { expression_matrix.baseName }

    // reproducible environment
    conda "${moduleDir}/environment.yml"
    
    // publish results to top-level results/ by default (or params.outdir)
    publishDir "${params.outdir ?: './results'}", mode: 'copy'

    input:
    path expression_matrix_ch
    val method
    val min_gene_mean
    val sample_cols
    path compute_cosine_script

    output:
    path "similarity_matrix.csv", emit: similarity_matrix
    path "similarity_heatmap.png", emit: heatmap

    script:
    // call existing R script. out_prefix = similarity (so outputs have expected names)
    """
    Rscript ${compute_cosine_script} \\
        --input ${expression_matrix_ch} \\
        --out_prefix similarity \\
        --method ${method} \\
        --min_gene_mean ${min_gene_mean} \\
        --sample_cols "${sample_cols}"
    """
}

workflow COMPUTE_SIMILARITY {
    take:
    expression_matrix_ch
    method
    min_gene_mean
    sample_cols

    main:
    def compute_similarity_script_ch = Channel.fromPath("${projectDir}/bin/compute_cosine.R")
    COMPUTE_SIMILARITY_PROCESS(expression_matrix_ch,
        method,
        min_gene_mean,
        sample_cols,
        compute_similarity_script_ch)
    
    emit:
    similarity_matrix = COMPUTE_SIMILARITY_PROCESS.out.similarity_matrix
    heatmap = COMPUTE_SIMILARITY_PROCESS.out.heatmap
}
