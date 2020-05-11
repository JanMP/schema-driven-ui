import React from 'react'
import {DateTimeInput} from 'semantic-ui-calendar-react'
import connectWithFormField from '/imports/ui/parts/connectWithFormField'


export default CustomDateTimeField = connectWithFormField ({value, onChange, placeholder}) ->
  
  value ?= 'kein Datum'
  placeholder ?= 'Bitte Datum eingeben'
  transformedValue = moment "#{value[0..7]}T#{value[8..11]}"
  

  <DateTimeInput
    localization="de"
    placeholder={placeholder}
    value={transformedValue}
    onChange={(e,d) -> onChange d.value}
    dateFormat="L, LT"
    dateTimeFormat="YYYYMMDDHHmm"
  />
 