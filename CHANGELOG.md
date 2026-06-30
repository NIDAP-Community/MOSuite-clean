# Code Ocean capsule - MOSuite - clean raw counts

## Development version

- Improved the Code Ocean parameter UI for the clean capsule (#2).

## v4.0

- Use the MOSuite v0.3.0 docker image.
- Fix: remove `regex_moo` parameter from configuration. multiOmicDataSet input files are now required to follow the standardized naming pattern (`.*\.rds$`).

## v3.0

Add parameters and improve descriptions.

<https://poc-nci.codeocean.io/capsule/5801113/tree/v3> (`337b281`)

## v2.0

Use a regular expression to find the multiOmicDataSet RDS file in the data/ directory.

<https://poc-nci.codeocean.io/capsule/5801113/tree/v2> (`44fbd50`)

## v1.0

First release of MOSuite-clean on Code Ocean with minimal parameters as a proof-of-concept:
- input multiOmicDataSet
- clean up column names
- count type

<https://poc-nci.codeocean.io/capsule/5801113/tree/v1> (`93c193c`)
