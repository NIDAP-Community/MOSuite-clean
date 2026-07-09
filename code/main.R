#!/usr/bin/env Rscript
library(argparse)
library(glue)
library(readr)
library(stringr)
library(dplyr)
devtools::load_all('/code/MOSuite')

# set up capsule environment
setup_capsule_environment()

# parse CLI arguments
parser <- ArgumentParser()

parser$add_argument(
  "--sample_id_colname",
  type = "character",
  default = NULL,
  help = "Column name for sample IDs"
)
parser$add_argument(
  "--feature_id_colname",
  type = "character",
  default = NULL,
  help = "Column name for feature IDs"
)
parser$add_argument(
  "--samples_to_rename",
  type = "character",
  default = "",
  help = "Sample names to rename"
)
parser$add_argument("--cleanup_column_names", type = "logical", default = TRUE)
parser$add_argument("--count_type", type = "character", default = "raw")
parser$add_argument(
  "--split_gene_name",
  type = "logical",
  default = TRUE,
  help = "Split gene name column by special characters"
)
parser$add_argument(
  "--aggregate_rows_with_duplicate_gene_names",
  type = "logical",
  default = TRUE,
  help = "Aggregate counts for duplicate gene names"
)
parser$add_argument(
  "--gene_name_column_to_use_for_collapsing_duplicates",
  type = "character",
  default = "",
  help = "Column to use for collapsing duplicates"
)

args <- parser$parse_args()

# load multiOmicDataSet from data directory
moo <- load_moo_from_data_dir()

# run MOSuite
moo |>
  clean_raw_counts(
    count_type = args$count_type,
    sample_id_colname = args$sample_id_colname,
    feature_id_colname = args$feature_id_colname,
    samples_to_rename = parse_samples_to_rename(args$samples_to_rename),
    cleanup_column_names = args$cleanup_column_names,
    split_gene_name = args$split_gene_name,
    aggregate_rows_with_duplicate_gene_names = args$aggregate_rows_with_duplicate_gene_names,
    gene_name_column_to_use_for_collapsing_duplicates = args$gene_name_column_to_use_for_collapsing_duplicates
  ) |>
  write_rds(file.path(getOption("moo_plots_dir"), "..", "moo", "moo.rds"))
