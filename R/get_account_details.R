#' Get Uptime Robot account details
#'
#' Returns the account details
#' @param api_key The api_key
#' @export
#' @importFrom httr POST content
get_account_details = function(api_key = NULL) {
  api_key = get_token(api_key)
  res = httr::POST("https://api.uptimerobot.com/v2/getAccountDetails",
                   body = list(api_key = api_key))
  con = httr::content(res, "text", encoding = "UTF-8")
  con = jsonlite::fromJSON(con)
  message("This return will change in future")
  con
}
