import React from 'react'
import {DateTimeInput} from 'semantic-ui-calendar-react'
import connectWithFormField from './connectWithFormField'


export default TimeField = connectWithFormField ({value, onChange, placeholder}) ->
  
  value ?= 'kein Datum'
  placeholder ?= 'Bitte Datum eingeben'
  transformedValue = moment "#{value[0..7]}T#{value[8..11]}"
  

  <h1>got the new component now</h1>
 