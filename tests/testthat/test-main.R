test_that("code/run executes successfully with default CLI arguments", {
  # Create temporary workspace
  workspace <- tempfile("mosuite_clean_test_")
  dir.create(workspace)
  on.exit(unlink(workspace, recursive = TRUE), add = TRUE)

  # Set up directory structure
  code_dir <- file.path(workspace, "code")
  data_dir <- file.path(workspace, "data")
  results_dir <- file.path(code_dir, "..", "results")
  dir.create(code_dir)
  dir.create(data_dir)
  dir.create(results_dir)

  # Get test data from package tests directory
  repo_root <- normalizePath(file.path(dirname(getwd()), ".."))
  test_data_file <- file.path(repo_root, "tests", "data", "moo-raw.rds")

  expect_true(
    file.exists(test_data_file),
    info = paste("Test data file should exist at", test_data_file)
  )
  file.copy(test_data_file, file.path(data_dir, "moo.rds"))

  # Copy main.R and run script to workspace
  file.copy(
    file.path(repo_root, "code", "main.R"),
    file.path(code_dir, "main.R")
  )
  file.copy(
    file.path(repo_root, "code", "run"),
    file.path(code_dir, "run")
  )

  # Run the script from code directory
  old_wd <- getwd()
  setwd(code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  # Execute run script with default CLI arguments
  exit_code <- system2(
    "bash",
    args = c(
      "run",
      "--cleanup_column_names=TRUE",
      "--split_gene_name=TRUE",
      "--aggregate_rows_with_duplicate_gene_names=TRUE"
    )
  )

  # Check for successful execution
  expect_equal(exit_code, 0, info = "run script should execute without error")
  expect_true(
    file.exists(file.path(results_dir, "moo", "moo.rds")),
    info = "Output file moo.rds should be created"
  )

  # Validate output is a valid MOO object
  moo <- readr::read_rds(file.path(results_dir, "moo", "moo.rds"))
  expect_true(
    S7::S7_inherits(moo, MOSuite::multiOmicDataSet),
    info = "Output should be an S7 multiOmicDataSet object"
  )
})

test_that("code/run executes with custom CLI arguments", {
  # Create temporary workspace
  workspace <- tempfile("mosuite_clean_custom_test_")
  dir.create(workspace)
  on.exit(unlink(workspace, recursive = TRUE), add = TRUE)

  # Set up directory structure
  code_dir <- file.path(workspace, "code")
  data_dir <- file.path(workspace, "data")
  results_dir <- file.path(code_dir, "..", "results")
  dir.create(code_dir)
  dir.create(data_dir)
  dir.create(results_dir)

  # Get test data from package tests directory
  repo_root <- normalizePath(file.path(dirname(getwd()), ".."))
  test_data_file <- file.path(repo_root, "tests", "data", "moo-raw.rds")

  # Copy test data to workspace
  file.copy(test_data_file, file.path(data_dir, "moo.rds"))

  # Copy main.R and run script to workspace
  file.copy(
    file.path(repo_root, "code", "main.R"),
    file.path(code_dir, "main.R")
  )
  file.copy(
    file.path(repo_root, "code", "run"),
    file.path(code_dir, "run")
  )

  # Run the script from code directory
  old_wd <- getwd()
  setwd(code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  # Execute run script with custom CLI arguments
  exit_code <- system2(
    "bash",
    args = c(
      "run",
      "--count_type=raw",
      "--cleanup_column_names=FALSE",
      "--split_gene_name=FALSE",
      "--aggregate_rows_with_duplicate_gene_names=FALSE",
      "--group_colname=Group",
      "--colors_for_plots=blue,green,orange"
    )
  )

  # Check for successful execution
  expect_equal(
    exit_code,
    0,
    info = "run script with custom args should execute without error"
  )
  expect_true(
    file.exists(file.path(results_dir, "moo", "moo.rds")),
    info = "Output file moo.rds should be created with custom args"
  )

  # Validate output is a valid MOO object
  moo <- readr::read_rds(file.path(results_dir, "moo", "moo.rds"))
  expect_true(
    S7::S7_inherits(moo, MOSuite::multiOmicDataSet),
    info = "Output should be an S7 multiOmicDataSet object"
  )
})

test_that("app panel exposes read-depth group color parameters", {
  repo_root <- normalizePath(file.path(dirname(getwd()), ".."))
  panel <- jsonlite::read_json(
    file.path(repo_root, ".codeocean", "app-panel.json"),
    simplifyVector = TRUE
  )
  param_names <- panel$parameters$param_name
  param_categories <- stats::setNames(panel$parameters$category, param_names)
  category_names <- stats::setNames(panel$categories$name, panel$categories$id)

  expect_true("group_colname" %in% param_names)
  expect_true("colors_for_plots" %in% param_names)
  expect_equal(
    category_names[[param_categories[["group_colname"]]]],
    "Visualization"
  )
  expect_equal(
    category_names[[param_categories[["colors_for_plots"]]]],
    "Visualization"
  )
})

test_that("postInstall installs MOSuite FigOutSync branch", {
  repo_root <- normalizePath(file.path(dirname(getwd()), ".."))
  post_install <- readLines(file.path(repo_root, "environment", "postInstall"))

  expect_true(any(grepl("CCBR/MOSuite", post_install, fixed = TRUE)))
  expect_true(any(grepl("FigOutSync", post_install, fixed = TRUE)))
})
