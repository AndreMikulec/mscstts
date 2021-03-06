#' @title Find API Key for Microsoft Text To Speech (TTS) or Cognitive
#' Services
#'
#' @description Determines if \code{option(ms_tts_key)} or
#' \code{option(ms_tts_key)} is set.
#' If not, it stops and returns an error.  If so, returns the value.
#' @param api_key Microsoft Cognitive Services API key
#' @param error Should the function error if \code{api_key = NULL}?
#' @note You can either set the API key using
#' \code{option(ms_tts_key)} or have it accessible by
#' \code{api_key = Sys.getenv('MS_TTS_API_KEY")}, or
#' \code{api_key = Sys.getenv('MS_TTS_API_KEY1")}, or
#' \code{api_key = Sys.getenv('MS_TTS_API_KEY2")}
#' @return API key
#' @export
#' @examples
#' res = get_ms_tts_key(error = FALSE)
get_ms_tts_key = function(api_key = NULL, error = TRUE) {
  if (is.null(api_key)) {
    api_key = getOption("ms_tts_key")
  }
  get_key = function(x) {
    x = Sys.getenv(x)
    if (is.null(x)) {
      return(x)
    }
    if (x == "") {
      return(NULL)
    }
    return(x)
  }
  keys = c("MS_TTS_API_KEY",
           "MS_TTS_API_KEY1", "MS_TTS_API_KEY2")
  for (ikey in keys) {
    if (is.null(api_key)) {
      api_key = get_key(ikey)
    }
  }

  if (!is.null(api_key)){
    if (api_key %in% ""){
      api_key = NULL
    }
  }

  if (is.null(api_key) & error) {
    stop(paste0("MS API key not found, please set ",
                "option('ms_tts_key') for general use or ",
                "set environment variable MS_TTS_API_KEY, to be ",
                "accessed by Sys.getenv('MS_TTS_API_KEY')"))
  }
  return(api_key)
}

#' @rdname get_ms_tts_key
#' @export
have_ms_tts_key = function(api_key = NULL) {
  api_key = get_ms_tts_key(api_key = api_key, error = FALSE)
  !is.null(api_key)
}


#' @rdname get_ms_tts_key
#' @export
set_ms_tts_key = function(api_key) {
  options("ms_tts_key" = api_key)
  invisible(NULL)
}


#' @rdname get_ms_tts_key
#' @param  token_url authorization token URL
#' (if different or custom from the default)
#' @export
valid_ms_tts_key = function(api_key = NULL, token_url = NULL) {

  if(is.null(token_url)) {
    token_url = paste0('https://api.cognitive.microsoft.com/',
                       'sts/v1.0/issueToken')
  } else {
    token_url
  }
  print(paste0("token_url(valid): ", token_url))

  if (!have_ms_tts_key()) {
    return(FALSE)
  }
  api_key = get_ms_tts_key(api_key = api_key, error = TRUE)

  hdr = httr::add_headers('Ocp-Apim-Subscription-Key' =
                            api_key)
  res = httr::POST(token_url,
                   hdr, httr::content_type("text/plain"))
  return(httr::status_code(res) < 400)
}

#' Get Microsoft Text To Speech (TTS) or Cognitive
#' Services Token from API Key
#'
#' @param api_key Microsoft Cognitive Services API key
#' @param  token_url authorization token URL
#' (if different or custom from the default)
#'
#' @return A list of the request, and token
#' @export
#' @importFrom httr POST add_headers stop_for_status content content_type
#'
#' @examples
#' if (valid_ms_tts_key()) {
#'    token = get_ms_tts_token()
#' }
get_ms_tts_token = function(api_key = NULL, token_url = NULL) {

  if(is.null(token_url)) {
    token_url = paste0('https://api.cognitive.microsoft.com/',
                       'sts/v1.0/issueToken')
  } else {
    token_url
  }
  print(paste0("token_url(get): ", token_url))

  api_key = get_ms_tts_key(api_key = api_key, error = TRUE)

  hdr = httr::add_headers('Ocp-Apim-Subscription-Key' =
                            api_key)
  res = httr::POST(token_url,
                   hdr, httr::content_type("text/plain"))

  httr::stop_for_status(res)
  cr = httr::content(res)
  base64_token = rawToChar(cr)
  class(base64_token) = "token"
  list(request = res,
       # content = cr,
       token = base64_token)
}

