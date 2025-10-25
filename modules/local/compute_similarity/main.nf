nextflow.enable.dsl=2

process COMPUTE_SIMILARITY_PROCESS {
    tag { expression_matrix.baseName }

    // reproducible environment
    conda "${moduleDir}/environment.yml"
    
    // publish results to top-level results/ by default (or params.outdir)
    publishDir "${params.outdir ?: './results'}", mode: 'copy'

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

workflow COMPUTE_SIMILARITY {
    take:
    expression_matrix_ch

    main:
    COMPUTE_SIMILARITY_PROCESS(expression_matrix_ch)

    emit:
    similarity_matrix = COMPUTE_SIMILARITY_PROCESS.out.similarity_matrix
    heatmap = COMPUTE_SIMILARITY_PROCESS.out.heatmap
}
