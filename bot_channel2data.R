# update.packages(ask = FALSE, checkBuilt = TRUE)
# if (!requireNamespace('tidyverse', quietly = TRUE)) install.packages('tidyverse')
# if (!requireNamespace('jsonlite', quietly = TRUE)) install.packages('jsonlite')

library(tidyverse)
library(jsonlite)

my_channel <- '@bot_ceshi'
d = Sys.Date()
# token <- read_lines("token.txt")
# read token from GitHub action secret instead

token <- Sys.getenv('TELEGRAM_BOT_TOKEN')

threshold <- readr::read_file('id.txt') %>%
    as.integer()

url <- paste0('https://api.telegram.org/bot', 
           token, '/getUpdates?chat_id=', 
           my_channel, '&offset=-10')

print(url)

full_data <- jsonlite::fromJSON(url)

full_data <- full_data$result$channel_post %>%
    filter(message_id>threshold)

if (nrow(full_data) == 0) {
    print('Nothing to do.')
} else {
    batch <- tibble(
        id = full_data$message_id,
        date = full_data$date %>%
            lubridate::as_datetime() %>% as.Date(),
        pinned = if_else(
            !is.na(full_data$pinned_message$message_id), TRUE, FALSE
        ),
        message = full_data$text
    )
    
    readr::write_csv(batch, paste0('data/', Sys.Date(),'.csv'))
}

readr::write_file(as.character(max(batch$id)), 'id.txt', append = FALSE)
