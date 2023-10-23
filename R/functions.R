read_csv_clean <- function(path, separator = ",", skippedrows = 7){

  read_delim(path, delim = separator, skip = skippedrows) %>%
    janitor::clean_names() %>%

    return(.)
}

tidy_rawdata <- function(data){
  data.tidy <- data %>%
    filter(grepl("\\d+", id_number)) %>%

    return(.)
}


read_firstsample_name <- function(path, separator = ","){
  read_delim(path, delim = separator, skip = 1, n_max = 1, col_names = FALSE) %>%
    janitor::clean_names() %>%

    return(.)
}

get_samplenames <- function(data){
  data %>%
    filter(id_number == "Data File Name") %>%
    select(name) %>%

    return(.)
}

vectorize_samplenames <- function(filepath, allsamples_names, rownumber_tidydata){

  vector_allsamples <- read_firstsample_name(filepath) %>%
    .[["x2"]] %>%
    rbind(allsamples_names) %>%
    mutate(samplename = str_extract(name, "[\\w-]+(?=.qgd)"), .keep = "none") %>%
    .[["samplename"]] %>%
    rep(., each = rownumber_tidydata/length(.))

  return(vector_allsamples)
}

save_restructured <- function(tidy.data, samplenames, filepath){
  tidy.data %>%
    mutate(sample = samplenames, .before = id_number) %>%
    write_csv(., paste0(filepath, "_tidied.csv"))
}

