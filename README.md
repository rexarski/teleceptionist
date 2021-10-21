# teleceptionist

The idea is based on Yihui Xie's [twitter-blogdown](https://github.com/yihui/twitter-blogdown) which fetches Twitter messages weekly and generates content on a blog.

The `teleceptionist`, as the name suggests, is a bot (`bot_channel2data`) that listens to Telegram channels and ~~reposts to a blog~~ stores the text data in a CSV.

Another approach to do so is to use the IFTTT automation connecting to the Telegram channel of interest and a online spreadsheet service like Airtable. This approach, however, has its own fault. Due to the limitation API that utilized in IFTTT, the text message can only be fetched as plain text, thus losing part of data.

Technically speaking, the functional script is not a bot yet, since it only operates inside a repo and does not interact in a channel.

Additionally, the `bot_data2channel` is a bot sends pre-formatted messages to a channel. However, this is out of the automation loop.

The cron job for `bot_channel2data` is set to run every Friday at 12:00 PM.
