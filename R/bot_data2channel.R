library(telegram.bot)
library(tidyverse)
library(lubridate)
library(jsonlite)

my_channel <- '@bot_ceshi'
d = Sys.Date()
token <- read_lines("R/token.txt")

bot = Bot(token = token)

updates = bot$getUpdates()

files <- list.files('content/post') %>%
    str_replace_all('.md', '') %>%
    as_date() %>%
    as_tibble()

match <- filter(files, value==d)

if (nrow(match)==0) {
    print('Nothing to post today!')
} else {
    post_json <- read_json(paste0('content/post/',
                                  match$value[1],'.md'))
    title <- post_json$title
    img <- post_json$img
    
    if (is.null(img)) {
        bot$sendMessage(chat_id = my_channel,
                        text = title,
                        parse_mode = 'Markdown')
    } else {
        bot$sendPhoto(chat_id = my_channel,
                      photo = img,
                      caption = title,
                      parse_mode = 'Markdown')
    }
    
}

