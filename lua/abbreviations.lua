local scrap = require('scrap')

local patterns = {
  -- english
  {'{despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}', '{despe,sepa}rat{}'},
  {'{,in}consistan{cy,cies,t,tly}',       '{}consisten{}'},
  {'delimeter{,s}',                       'delimiter{}'},
  {'cal{a,e}nder{,s}',                    'cal{e}ndar{}'},
  {'{c,m}arraige{,s}',                    '{}arriage{}'},
  {'{,in}consistan{cy,cies,t,tly}',       '{}consisten{}'},
  {'{,non}existan{ce,t}',                 '{}existen{}'},
  {'d{e,i}screp{e,a}nc{y,ies}',           'd{i}screp{a}nc{}'},
  {'euphamis{m,ms,tic,tically}',          'euphemis{}'},
  {'{,re}impliment{,s,ing,ed,ation}',     '{}implement{}'},
  {'{agu,improv}ment{,s}',               '{argu,improve}ment{}'},
  {'inherant{,ly}',                       'inherent{}'},
  {'lastest',                             'latest'},
  {'{,un}nec{ce,ces,e}sar{y,ily}',        '{}nec{es}sar{}'},
  {'persistan{ce,t,tly}',                 'persisten{}'},
  {'{,ir}releven{ce,cy,t,tly}',           '{}relevan{}'},
  {'rec{co,com,o}mend{,s,ed,ing,ation}',  'rec{om}mend{}'},
  {'reproducable',                        'reproducible'},
  {'resouce{,s}',                         'resource{}'},
  {'teh{,n}',                             'the{n}'},
  {'alot',                                'a lot'},
  {'retun',                               'return'},
  {'{im,ex}pot',                          '{}port'},
  {'classame',                            'className'},
  {'{get,set}Sate',                       '{}State'},
  {'flaot',                               'float'},
  {'cosnt',                               'const'},
  {'braek',                               'break'},
  {'{,un}singed',                         '{}signed'},
  {'satic',                               'static'},
  {'trow',                                'throw'},
  {'inport',                              'import'},
  -- nederlands
  {'een{stemm,tal}ig{,heid}',          'één{}ig{}'},
  {'{seri,zo}e{r,v}en',                '{}ë{}en'},
  {'{,absorptie}coefficient',          '{}coëfficiënt'},
  {'intress{e,ant,ante}',              'interess{}'},
  {'proffessione{el,le}',              'profession{}'},
  {'aggressie{f,ve}',                  'agressie{}'},
  {'concervat{ie,or,rice,orium,isme}', 'conservat{}'}
}

local expanded = scrap.expand_many(patterns)
scrap.many_local_abbreviations(expanded)
