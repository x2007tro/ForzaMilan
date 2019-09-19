# ForzaMilan
Analyze soccer game stats to help Milan scouting

## Webapp design
- tab Player selection
  - options: position, age min/max, height min/max, league, dribbling, sprintspeed, agility, strength 
- tab Metrics
  - one table outline the recent match stats and key attributes from FIFA19
- tab Player Profile
  - once players are selected, his personal files can be retrieved
  - stats include: name, picture, country, stats from metrics tables
  - graph include: historical performance from metrics table

## Package required
- require(shiny)
- require(shinythemes)
- require(dplyr)
- require(magrittr)
- require(DT)
- require(RColorBrewer)
- require(stringi)
- require(readr)
