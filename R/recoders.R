#' @importFrom dplyr recode
recode_monitors = function(monitors) {
  monitors$type = dplyr::recode(monitors$type,
                                "1" = "http(s)", "2" = "keyword",
                                "3" = "ping", "4" = "port")
  monitors$sub_type = dplyr::recode(monitors$sub_type,
                                    "1" = "http (80)", "2" = "https (443)",
                                    "3" = "ftp (21)", "4" = "smtp (25)",
                                    "5" = "pop3 (110)", "6" = "imap (143)",
                                    "99" = "custom")
  monitors$keyword_type = dplyr::recode(as.character(monitors$keyword_type),
                                        "1" = "exists", "2" = "not exists")

  monitors$status = dplyr::recode(monitors$status,
                                  "0" = "paused", "1" = "not checked yet",
                                  "2" = "up", "8" = "seems down",
                                  "9" = "down")

  if (!is.null(monitors$logs[[1]]$type)) {
    monitors$logs[[1]]$type = dplyr::recode(monitors$logs[[1]]$type,
                                            "1" = "down", "2" = "up",
                                            "99" = "paused", "98" = "started")
  }

  return(monitors)
}
