# bookIT

Bokningssystem för Chalmers IT  
*Byggt i Ruby on Rails av Ndushi*

Features:

 * Administration av bokningar + arrangemangsanmälningar (endast VO)
 * Regelsystem med matchningar mot dynamiskt definerade regler


Kör följande kommando för att skapa 'Hubben' och 'Grupprummet':

```
rake db:seed
```

### Setup med docker:
för att bygga en lokal utvecklings miljö:
```
docker-compos up --build
```
För att lösa Autentiering mot accounts, lägg till:
```
0.0.0.0       local.chalmers.it
```
i `/etc/hosts`

För att starta:
```
docker-compose up
```

### rake tasks
Lägg till följande till cron: `cd path_to_bookit && path_to_rake RAILS_ENV=production bookit:remind`
Bör köras varje timme


* `rake bookit:parse`, `rake bookit:clean`, `rake bookit:reparse`
	* Parsear [Chalmers Läsårstider](https://www.student.chalmers.se/sp/academic_year_list) efter läsperiodstider
	* Skapa `config/matchers.rb` för att definera vad de innebär


#### Syntax för `config/matchers.rb`:

```
match regexp, times_array [, options]
```

##### Times array:
Array of strings in this format: `HH:MM-HH:MM`

##### Options:
Possible keys:

* `:blacklist`
	*  `(boolean)`
* `:title`
	*  `(string)`
* `:days`
	* An array of weekdays: `[:mon, :tue, :wed, :thu, :fri, :sat, :sun]`
	* or a shorthand value `:weekdays`, `:weekends`, `:all`.



##### Exempel:
```
# Mellan 15-00 & 11-12 på helger får man inte boka (under läsperioder)
match /Läsperiod \d/, ['15:00-24:00', '11:00-12:00'], days: :weekends, blacklist: true

# Mellan 08-00 på måndag, tisdag & onsdag i tentaperioder får man boka
match /Tentamensperiod \d/, ['08:00-24:00'], days: [:mon, :tue, :wed]

# Mellan 11-12 på alla dagar får man boka. Whitelistningen har en custom titel
match /Tentamensperiod \d/, ['11:00-12:00'], days: :all, title: 'Luncher under tentaperioder'
```
