# Uptime Robot

Grab data from uptime robot via it's [API](https://uptimerobot.com/api).

  * This package does not include all features of the API
  * The functions it does have, are missing arguments

To get a key

  * log on to uptime robot
  * My settings
  * API Settings. I recommend monitor specific API keys to avoid mistakes
  
## Usage

Install the package in the usual way

```
remotes::install_github("jumpingrivers/uprobot")
library("uprobot")
```
To use the the package, you need an upRobot account and API key (see below). 
You can either pass the API key explicity, or set is as an environmental
variable `UPTIME_ROBOT_TOKEN` in your `.Renviron`
```
mon = get_monitors(api_key = "XXX", logs = TRUE)
mon$logs
# If set in your .Renviron
# get_monitors(logs = TRUE)
```
