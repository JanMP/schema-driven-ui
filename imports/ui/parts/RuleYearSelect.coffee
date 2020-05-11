import React from 'react'
import connectWithFormField from '/imports/ui/parts/connectWithFormField'
import {Dropdown} from 'semantic-ui-react'

options = [2015..2025].map (year) ->
  key: year
  text: "#{year}"
  value: year

export default RuleYearSelect = connectWithFormField ({value, onChange}) ->

  <Dropdown
    placeholder='Gültigkeitsjahre für Regeln'
    value={value ? []}
    onChange={(e, d) -> onChange (d.value ? []).sort()}
    options={options}
    fluid multiple selection
  />