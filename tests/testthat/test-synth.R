context("Trying out the API")

test_that(desc = "Trying the API to see if the example works", {
  skip_on_cran()

  if (valid_ms_tts_key()) {
    res = ms_synthesize(
      script = "hey, how are you doing? I'm doing pretty good",
      output_format = "audio-16khz-128kbitrate-mono-mp3")
    tmp <- tempfile()
    writeBin(res$content, con = tmp)
    mp3 = tuneR::readMP3(tmp)
    expect_true(file.size(tmp) > 50000)
  } else if (valid_ms_tts_key(token_url = "https://westus.api.cognitive.microsoft.com/sts/v1.0/issueToken")) {
    res = ms_synthesize(
      script = "hey, how are you doing? I'm doing pretty good",
      token_url = "https://westus.api.cognitive.microsoft.com/sts/v1.0/issueToken",
      synth_url = "https://westus.tts.speech.microsoft.com/cognitiveservices/v1",
      output_format = "audio-16khz-128kbitrate-mono-mp3")
    tmp <- tempfile()
    writeBin(res$content, con = tmp)
    mp3 = tuneR::readMP3(tmp)
    expect_true(file.size(tmp) > 50000)
  }

})
