test_that("code/run executes successfully with default CLI arguments", {
  setup <- setup_cli_workspace("mosuite_clean_test_")
  on.exit(unlink(setup$workspace, recursive = TRUE), add = TRUE)

  old_wd <- getwd()
  setwd(setup$code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  exit_code <- system2(
    "bash",
    args = c(
      "run",
      "--cleanup_column_names=TRUE",
      "--split_gene_name=TRUE",
      "--aggregate_rows_with_duplicate_gene_names=TRUE"
    )
  )

  expect_equal(exit_code, 0, info = "run script should execute without error")
  expect_outputs_created(setup$results_dir)
})

test_that("code/run executes with custom CLI arguments", {
  setup <- setup_cli_workspace("mosuite_clean_custom_test_")
  on.exit(unlink(setup$workspace, recursive = TRUE), add = TRUE)

  old_wd <- getwd()
  setwd(setup$code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  exit_code <- system2(
    "bash",
    args = c(
      "run",
      "--count_type=raw",
      "--cleanup_column_names=FALSE",
      "--split_gene_name=FALSE",
      "--aggregate_rows_with_duplicate_gene_names=FALSE"
    )
  )

  expect_equal(
    exit_code,
    0,
    info = "run script with custom args should execute without error"
  )
  expect_outputs_created(setup$results_dir)
})
