
match /Läsperiod \d/, ['15:00-00:00'], days: :weekends
match /Tentamensperiod \d/, ['10:00-00:00'], days: :all
match /Tentamensperiod \d/, ['11:00-12:00'], days: :all, blacklist: true, title: 'Ej luncher under tentaperioder'


