get_token = function(api_key) {
  if (is.null(api_key)) {
    api_key = Sys.getenv("UPTIME_ROBOT_TOKEN", NA)
  }
  if (is.na(api_key)) {
    stop("API Key missing", call. = FALSE)
  }
  api_key
}
