# bookIT
 * language javascript ruby
A Webbased booking system.
Fetures: 
 * Admin system
 * ldap intergation
 * Special rules on set timeslots.
 * Repeat bookings

Install instructions:

 

Skapa 'Hubben' och 'Grupprummet':

```
rake db:seed
```

## rake tasks

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
