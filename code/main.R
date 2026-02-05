#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(MOSuite)
library(readr)
library(stringr)
library(dplyr)

# set up results directory
results_dir <- file.path('..','results')
plots_dir <- file.path(results_dir, 'figures')
options(moo_plots_dir = plots_dir, moo_save_plots = TRUE)

# log installed packages & versions
pkg_versions <- tibble::as_tibble(installed.packages())
write_csv(pkg_versions, file.path(results_dir, 'r-packages.csv'))

# parse CLI arguments
parser <- ArgumentParser()

parser$add_argument("--sample_id_colname", type="character", default=NULL, help="Column name for sample IDs")
parser$add_argument("--feature_id_colname", type="character", default=NULL, help="Column name for feature IDs")
parser$add_argument("--samples_to_rename", type="character", default="", help="Sample names to rename")
parser$add_argument("--cleanup_column_names", type="logical", default=TRUE)
parser$add_argument("--count_type", type="character", default="raw")
parser$add_argument("--split_gene_name", type="logical", default=TRUE, help="Split gene name column by special characters")
parser$add_argument("--aggregate_rows_with_duplicate_gene_names", type="logical", default=TRUE, help="Aggregate counts for duplicate gene names")
parser$add_argument("--gene_name_column_to_use_for_collapsing_duplicates", type="character", default="", help="Column to use for collapsing duplicates")

args <- parser$parse_args()

# validate inputs
regex_moo <- ".*\\.rds$"
data_files <- list.files(file.path('../data'), recursive = TRUE, full.names = TRUE)
moo_files <- Filter(\(x) str_detect(x, regex(regex_moo, ignore_case = TRUE)), data_files)

if (length(moo_files) == 0) {
    stop(glue("No files matching regex: {regex_moo}"))
}
moo_filename <- moo_files[1]
moo <- read_rds(moo_filename)
message(glue('Reading multiOmicDataSet from {moo_filename}'))
if (!inherits(moo, 'MOSuite::multiOmicDataSet')) {
    stop(glue('The input is not a multiOmicDataSet. class: {class(moo)}'))
}

# run MOSuite
moo |> 
    clean_raw_counts(
        count_type = args$count_type,
        sample_id_colname = args$sample_id_colname,
        feature_id_colname = args$feature_id_colname,
        samples_to_rename = args$samples_to_rename,
        cleanup_column_names = args$cleanup_column_names,
        split_gene_name = args$split_gene_name,
        aggregate_rows_with_duplicate_gene_names = args$aggregate_rows_with_duplicate_gene_names,
        gene_name_column_to_use_for_collapsing_duplicates = args$gene_name_column_to_use_for_collapsing_duplicates
        ) |> 
    write_rds(file.path(results_dir, 'moo', 'moo.rds'))