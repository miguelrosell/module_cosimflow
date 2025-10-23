nextflow.enable.dsl=2

process compute_similarity_process {
    tag { expression_matrix.baseName }

    // publish results to top-level results/ by default (or params.outdir)
    publishDir "${params.outdir ?: './results'}", mode: 'copy'

    // reproducible environment
    conda "${projectDir}/envs/r_env.yml"

    input:
    path expression_matrix

    output:
    path "similarity_matrix.csv", emit: similarity_matrix
    path "similarity_heatmap.png", emit: heatmap

    script:
    // call existing R script. out_prefix = similarity (so outputs have expected names)
    """
    Rscript ${projectDir}/bin/compute_cosine.R \\
        --input ${expression_matrix} \\
        --out_prefix similarity \\
        --method ${params.method ?: 'cosine'} \\
        --min_gene_mean ${params.min_gene_mean ?: 0.0} \\
        --sample_cols "${params.sample_cols ?: 'auto'}"
    """
}

workflow compute_similarity {
    take:
    expression_matrix_ch

    main:
    compute_similarity_process(expression_matrix_ch)

    emit:
    similarity_matrix = compute_similarity_process.out.similarity_matrix
    heatmap = compute_similarity_process.out.heatmap
}
