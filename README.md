# Uptime Robot

Grab data from uptime robot via it's [API](https://uptimerobot.com/api).

  * This package does not include all features of the API
  * The functions it does have, are missing arguments

To get a key

  * log on to uptime robot
  * My settings
  * API Settings. I recommend monitor specific API keys to avoid mistakes
  
## Usage

Install the package

```
library("uprobot")
api_key = "XXX"
mon = get_monitors(api_key, logs = TRUE)
mon$logs
```
