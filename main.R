 #pacman::p_install_gh("hauselin/ollamar")
 #ollamar::pull("llama3.1")
 
 ### Libraries
 pacman::p_load(
   "httr2",
   "glue",
   "tidyverse"
 )
 ollamar::list_models()
 
 ### Make a parallel request to classify sentences (sentiment)
 parallelSentiment <- function(texts) {
   # create httr2_request objects for each text, using the same system prompt
   reqs <- lapply(texts, function(text) {
     prompt <- glue("
                    Your only task/role is to evaluate the sentiment of a given
                    text, and your response have to be one of the following:
                    'positive', 'negative', or 'other'. Product review: {text}.
                    Answer this question with exactly one word!
                    ")
     ollamar::generate("llama3.1", prompt, output = "req")
   })
   # perform parallel request
   req_perform_parallel(reqs) |>
    sapply(ollamar::resp_process, "text")
 }
 
 # process the responses
 #c("It was great!", "Worse than indian intelligence") |>
 #  parallelSentiment()
     