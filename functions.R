
### Using oligo package to read and normalize the data ###
read_norm <- function(celfile.path) {
  list = list.files(celfile.path, full.names = TRUE)
  data = read.celfiles(list)
  eset <- oligo::rma(data)
  eset.rma <- exprs(eset)
  colnames(eset.rma) = c(str_sub(colnames(eset.rma), 1, 10))
  return(eset.rma)
}

### Get the processed GEO with the more informative phenotypic and sample data ###
# load series and platform data from GEO
# load simulated data:
get_geo <- function(geo) {
  gds <-
    getGEO(
      geo,
      GSElimits = NULL,
      GSEMatrix = TRUE,
      AnnotGPL = FALSE,
      getGPL = FALSE
    )
  sampleInfo = pData(gds[[1]])
  return(sampleInfo)
}

# info: information/metadata about each sample
clean_info <- function(sampleInfo) {
  info <-
    sampleInfo %>% dplyr::select(
      geo_accession,
      `gender:ch1`,
      `Sex:ch1`,
      `batch:ch1`,
      `cell type:ch1`,
      `age (yrs):ch1`
    ) %>% dplyr::rename(
      Individual = geo_accession,
      CellType = `cell type:ch1`,
      Batch = `batch:ch1`,
      Age = `age (yrs):ch1`
    ) %>% mutate(sex = coalesce(`Sex:ch1`, `gender:ch1`)) %>% mutate(
      Sex = if_else(sex == "male" | sex == "Male", "1", sex),
      Sex = if_else(sex == "female" |
                      sex == "Female", "2", Sex),
      CellType = if_else(str_detect(CellType, "T4"), "T4", CellType),
      CellType = if_else(str_detect(CellType, "monocytes"), "monocytes", CellType),
      Age = as.numeric(Age)
    ) %>% dplyr::select(-`gender:ch1`, -`Sex:ch1`, -sex)
  return(info)
}