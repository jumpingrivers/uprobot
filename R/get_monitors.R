check_uprobot_rtn = function(con) {
  if (is.null(con$error)) return(invisible(NULL))
  msg = paste0("Uprobot error:", con$error$type, "-", con$error$parameter_name)
  stop(msg, call. = FALSE)
}

#' Get monitors
#'
#' @inheritParams get_account_details
#' @param logs Should the logs be returned (default FALSE)
#' @param all_uptime_ratio Uptime ratio since monitoring began (default FALSE).
#' @param all_time_uptime_durations All time uptime durations (default FALSE).
#' @param custom_uptime_ratios Defines the number of days to calculate the uptime ratio(s) for.
#' Ex: custom_uptime_ratios=7-30-45 to get the uptime ratios for those periods.
#' @param response_times Logical default \code{FALSE}.
#' @details The argument order may change. So use named arguments. I also want to
#' make this function to always return a tibble with the same number of columns. However,
#' the api itself isn't really consistent and depends on the arguments passed.
#' @seealso https://uptimerobot.com/api
#' @export
get_monitors = function(api_key  = NULL,
                        logs = FALSE,
                        all_uptime_ratio = FALSE,
                        all_time_uptime_durations = FALSE,
                        custom_uptime_ratios = NULL,
                        response_times = FALSE
) {
  api_key = get_token(api_key)
  res = httr::POST("https://api.uptimerobot.com/v2/getMonitors",
                   body = list(api_key = api_key,
                               logs = as.integer(logs),
                               all_uptime_ratio = as.integer(all_uptime_ratio),
                               custom_uptime_ratios = custom_uptime_ratios,
                               response_times = as.integer(response_times)))
  con = httr::content(res, "text", encoding = "UTF-8")
  con = jsonlite::fromJSON(con)
  check_uprobot_rtn(con)
  monitors = con$monitors
  monitors$create_datetime = lubridate::as_datetime(monitors$create_datetime)

  if (isTRUE(logs)) {
    up_logs = monitors$logs[[1]]
    up_logs$datetime = lubridate::as_datetime(up_logs$datetime)
    # reason is a list column: expand and delete
    up_logs$code = up_logs$reason$code
    up_logs$detail = up_logs$reason$detail
    up_logs = up_logs[, -4]
    monitors$logs[[1]] = tibble::as_tibble(up_logs)
  } else {
    monitors$logs[[1]] = list(tibble::tibble(type = "", datetime = "",
                                             duration = "", code = "",
                                             detail = ""))
  }

  if (isTRUE(response_times)) {
    res_times = monitors$response_times[[1]]

    res_times = tibble::as_tibble(res_times)
    if (ncol(res_times) == 0L) {
      res_times = tibble::tibble(datatime = character(0), value = integer(0))
    } else {
      res_times$datetime = lubridate::as_datetime(res_times$datetime)
    }
    monitors$response_times[[1]] = res_times
  } else {
    monitors$response_times[[1]] = list(tibble::tibble(datetime = "", value = integer()))
  }

  if (is.null(custom_uptime_ratios)) {
    monitors$custom_uptime_ratios = NA
  }
  monitors = recode_monitors(monitors)
  monitors = tibble::as_tibble(monitors)
  monitors
}
