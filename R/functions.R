#' Title
#'
#' @param path
#' @param separator
#' @param skippedrows
#'
#' @return
#'
#' @examples
read_csv_clean <- function(path, separator = ",", skippedrows = 7){

  read_delim(path, delim = separator, skip = skippedrows) %>%
    janitor::clean_names() %>%

    return(.)
}

#' Title
#'
#' @param data
#'
#' @return
#'
#' @examples
tidy_rawdata <- function(data){
  data.tidy <- data %>%
    filter(grepl("\\d+", id_number)) %>%

    return(.)
}


#' Title
#'
#' @param path
#' @param separator
#'
#' @return
#'
#' @examples
read_firstsample_name <- function(path, separator = ","){
  read_delim(path, delim = separator, skip = 1, n_max = 1, col_names = FALSE) %>%
    janitor::clean_names() %>%

    return(.)
}

#' Title
#'
#' @param data
#'
#' @return
#'
#' @examples
get_samplenames <- function(data){
  data %>%
    filter(id_number == "Data File Name") %>%
    select(name) %>%

    return(.)
}

#' Title
#'
#' @param filepath
#' @param allsamples_names
#' @param rownumber_tidydata
#'
#' @return
#'
#' @examples
vectorize_samplenames <- function(filepath, allsamples_names, rownumber_tidydata){

  vector_allsamples <- read_firstsample_name(filepath) %>%
    .[["x2"]] %>%
    rbind(allsamples_names) %>%
    mutate(samplename = str_extract(name, "[\\w-]+(?=.qgd)"), .keep = "none") %>%
    .[["samplename"]] %>%
    rep(., each = rownumber_tidydata/length(.))

  return(vector_allsamples)
}

#' Title
#'
#' @param tidy.data
#' @param samplenames
#' @param filepath
#'
#' @return
#'
#' @examples

restructure <- function(tidy.data, samplenames){
  tidy.data %>%
    mutate(sample = samplenames, .before = id_number)
}


#' Restructure gcms postrun rawdata
#'
#' Adds the name of sample as column next to the data columns
#'
#' Functions which gets the name of the sample from the row in the rawdata
#' and then adds it as the column "sample" as first column, allowing for
#' further data manipulation, e.g. pivoting, selection, filtering, etc.
#'
#' @param filepath
#' @param delimiter
#' @param write
#'
#' @return
#' @export
#' @import janitor
#' @import readr
#' @import stringr
#' @import dplyr
#'
#'
#' @examples
restructure <- function(filepath, delimiter = ",", write = FALSE){
  filename <- str_extract(filepath, "[\\w-]+?(?=\\.)")
  filepath_wo_extensions <- str_extract(filepath, ".+(?=\\.\\w{3})")
  data <- read_csv_clean(filepath)
  data.tidy <- tidy_rawdata(data)

  samplenames_all <- get_samplenames(data)
  vector_allsamples_names <- vectorize_samplenames(filepath, samplenames_all, nrow(data.tidy))

  data.restructued <- restructure(tidy.data, samplenames)

  if(write == TRUE){write_csv(data.restructured, paste0(filepath_wo_extensions, "_tidied.csv"))}


  return(data.restructured)
}
