library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.

source("config.R")
source("functions.R")

# Set target-specific options such as packages.
tar_option_set(packages = "dplyr")

# End this file with a list of target objects.
list(
  tar_target(name = eset.rma,
             command = read_norm(celfile.path)),
  tar_target(name = sampleInfo,
             command = get_geo(geo)),
  tar_target(name = info,
             command = clean_info(sampleInfo)),
  tar_target(
    name = varPart2,
    command = fitExtractVarPartModel(
      exprObj = eset.rma[1:30000, ],
      formula = form,
      data = info
    )
  )
)
