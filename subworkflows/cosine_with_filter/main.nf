nextflow.enable.dsl=2

include { custom_matrixfilter } from 'nf-core/modules/custom_matrixfilter'
include { compute_cosine } from '../../modules/compute_cosine/main.nf'

workflow cosine_with_filter {
    take:
        expr_file
    main:
        filtered_expr = (params.use_matrixfilter ? custom_matrixfilter(expr_file).filtered_matrix : expr_file)
        cosine_result = compute_cosine(filtered_expr)
    emit:
        cosine_result.out_cosine_matrix
        cosine_result.out_heatmap
}
