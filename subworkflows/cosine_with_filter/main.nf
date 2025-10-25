// subworkflows/cosine_with_filter/main.nf
nextflow.enable.dsl=2

include { CUSTOM_MATRIXFILTER } from '../../modules/nf-core/custom_matrixfilter'
include { COMPUTE_SIMILARITY } from '../../modules/local/compute_similarity'

workflow COSINE_WITH_FILTER {
    take:
        expr_file
        method
        min_gene_mean
        sample_cols
    main:
        filtered_expr = (params.use_matrixfilter ? CUSTOM_MATRIXFILTER(expr_file).filtered_matrix : expr_file)
        cosine_result = COMPUTE_SIMILARITY(
            expression_matrix_ch: filtered_expr, 
            method: method,                    
            min_gene_mean: min_gene_mean,      
            sample_cols: sample_cols
        )    
    emit:
        cosine_result.similarity_matrix
        cosine_result.heatmap
}
