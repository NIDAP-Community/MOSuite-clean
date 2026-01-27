#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(MOSuite)
library(readr)
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

parser$add_argument("--moo", type="character", required=TRUE)
parser$add_argument("--cleanup_column_names", type="logical", default=TRUE)
parser$add_argument("--count_type", type="character", default="raw")

args <- parser$parse_args()

# validate inputs
for (f in c(args$moo)) {
    if (!file.exists(f)) {
        stop(glue("File not found: {f}"))
    }
}
moo <- read_rds(args$moo)
if (!inherits(moo, 'MOSuite::multiOmicDataSet')) {
    stop(glue('The input is not a multiOmicDataSet. class: {class(moo)}'))
}

# run MOSuite
moo |> 
    clean_raw_counts(
        count_type = args$count_type,
        cleanup_column_names = args$cleanup_column_names
        ) |> 
    write_rds(file.path(results_dir, 'moo.rds'))