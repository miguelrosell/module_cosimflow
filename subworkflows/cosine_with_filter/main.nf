nextflow.enable.dsl=2

include { CUSTOM_MATRIXFILTER } from '../../modules/nf-core/custom_matrixfilter'
include { COMPUTE_SIMILARITY } from '../../modules/local/compute_similarity/main.nf'

workflow COSINE_WITH_FILTER {
    take:
        expr_file
    main:
        filtered_expr = (params.use_matrixfilter ? CUSTOM_MATRIXFILTER(expr_file).filtered_matrix : expr_file)
        cosine_result = COMPUTE_SIMILARITY(filtered_expr)
    emit:
        cosine_result.out_cosine_matrix
        cosine_result.out_heatmap
}
