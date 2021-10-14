update.packages(ask = FALSE, checkBuilt = TRUE)
if (!requireNamespace('tidyverse', quietly = TRUE)) install.packages('tidyverse')
if (!requireNamespace('jsonlite', quietly = TRUE)) install.packages('jsonlite')


full_data <- jsonlite::fromJSON('https://tg.i-c-a.su/json/datastitches/')

threshold <- read_file('data/id.txt') %>%
    as.integer()

full_data <- full_data$messages %>%
    filter(id > threshold)

if (nrow(full_data) == 0) {
    print('Nothing to do.')
} else {
    batch <- tibble(
        id = full_data$id,
        pinned = full_data$pinned,
        date = full_data$date,
        message = full_data$message,
        type = case_when(
            !is.na(full_data$media$photo$id) ~ 'photo',
            !is.na(full_data$media$webpage$url) ~ 'webpage',
            !is.na(full_data$media$document$id) ~ 'document'
        ),
        web_url = full_data$media$webpage$url,
        web_site = full_data$media$webpage$site_name,
        web_title = full_data$media$webpage$title,
        web_description = full_data$media$webpage$description,
    )
    
    write_csv(batch, paste0('data/channel/', Sys.Date(),'.csv'))
}

write_file(as.character(max(batch$id)), 'data/id.txt', append = FALSE)

          