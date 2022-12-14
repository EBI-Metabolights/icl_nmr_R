#' hurricane
#'
#' Run the NMR pipeline start to finish:
#' 1] statistical decomposition
#' 2] annotation matching
#' 3] export results
#' 4] visualisation [in progress in upstream repository]
#' Also saves to RDS outputs from statistical decomposition
#' A default params.yaml file will be used if none is supplied.
#' The outline of the params file can be found in the repo readme.md
#'
#' @param params_loc location of the params.yaml file containing
#'  pipeline run parameters.
#' @param params_obj A populated yaml object containing the parameters.
#' This parameter is intended for use when being run from galaxy.
#' @return N/A but .RDS and .TSV files are saved, see description.
#' @export
hurricane <- function(params_loc, params_obj) {
    default <- FALSE
    if (isFALSE(missing(params_obj))) {
        run_params <- params_obj
    } else if (missing(params_loc)) {
        # load default params
        filepath <- system.file(
            "extdata", "default_params.yaml", package="ImperialNMRTool")
        run_params <- yaml::yaml.load_file(filepath)
        default <- TRUE
    } else {
        # load supplied params
        run_params <- yaml::yaml.load_file(params_loc)
    }
    # currently loading default files does not work.
    if (isTRUE(default)) {
        peaks_path <- system.file(
            "extdata", "peaks.RDS", package="ImperialNMRTool")
        spec_path <- system.file(
            "extdata", "spec.RDS", package="ImperialNMRTool")
        refdb_path <- spec_path <- system.file(
            "extdata", "hmdb_spectra_28FEB2022.RDS", package="ImperialNMRTool")

        peaks <- readRDS(peaks_path)
        spec <- readRDS(spec_path)
        refdb <- readRDS(refdb_path)
    } else {
        peaks <- readRDS(run_params$general_pars$peaks_location)
        spec <- readRDS(run_params$general_pars$spec_location)
        refdb <- readRDS(run_params$am_pars$refdb_file)
    }


    s_d_results <- stat_decomp(
        peaks = peaks,
        spec = spec,
        params = run_params)

    saveRDS(s_d_results$target, stringr::str_c(
        run_params$general_pars$output_dir, "target.RDS"))
    saveRDS(s_d_results$ppeaks, stringr::str_c(
        run_params$general_pars$output_dir, "ppeaks.RDS"))

    matches <- annotation_matching(
        peaks = peaks,
        target = s_d_results$target,
        ppeaks = s_d_results$ppeaks,
        spec = spec,
        refdb = refdb,
        params = run_params)


    exportMatches(
        matches = matches,
        X = spec,
        rankLimit = run_params$am_pars$rank_limit,
        output_dir = run_params$general_pars$output_dir)

}
