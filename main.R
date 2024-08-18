 #pacman::p_install_gh("hauselin/ollamar")
 #ollamar::pull("phi3:medium")
 
 ### Libraries
 pacman::p_load(
   "httr2",
   "glue",
   "tidyverse",
   "svglite"
 )
 ollamar::list_models()
 
 ### Make a parallel request to classify sentences (sentiment)
 parallelSentiment <- function(texts, model = "llama3.1") {
   # create httr2_request objects for each text, using the same system prompt
   reqs <- lapply(texts, function(text) {
     prompt <- glue("
                    Your only task/role is to evaluate the sentiment of a given
                    text, and your response have to be one of the following:
                    'positive', 'negative', or 'other'. Product review: {text}.
                    Answer this question with exactly one word!
                    ")
     ollamar::generate(model, prompt, output = "req")
   })
   # perform parallel request
   req_perform_parallel(reqs) |>
    sapply(ollamar::resp_process, "text")
 }
 
 ### Using SVG device for ggplot2
 asSVG <- function(chart, width = 16, height = 9, scaling = 1, save = F, name = "") {
   s <- svgstring(width, height, scaling = scaling)  # Start the SVG device
   print(chart)          # Print the ggplot object to the SVG device
   svg_content <- s()    # Capture the SVG content
   invisible(dev.off())  # Close the SVG device
   if (save) htmltools::save_html(htmltools::HTML(svg_content), name)
   htmltools::HTML(svg_content)  # Return the SVG content as HTML
 }
 