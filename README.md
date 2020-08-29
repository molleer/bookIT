# bookIT

## Calendar docs

-   [Full Calendar](https://fullcalendar.io/docs)

##### Exempel:

```
# Mellan 15-00 & 11-12 på helger får man inte boka (under läsperioder)
match /Läsperiod \d/, ['15:00-24:00', '11:00-12:00'], days: :weekends, blacklist: true

# Mellan 08-00 på måndag, tisdag & onsdag i tentaperioder får man boka
match /Tentamensperiod \d/, ['08:00-24:00'], days: [:mon, :tue, :wed]

# Mellan 11-12 på alla dagar får man boka. Whitelistningen har en custom titel
match /Tentamensperiod \d/, ['11:00-12:00'], days: :all, title: 'Luncher under tentaperioder'
```
