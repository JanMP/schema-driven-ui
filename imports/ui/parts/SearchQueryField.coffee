import {Meteor} from 'meteor/meteor'
import meteorApply from '../../helpers/meteorApply'
import React, {useEffect, useState} from 'react'
import connectWithFormField from './connectWithFormField'
import {Dropdown} from 'semantic-ui-react'

export default SearchQueryField = connectWithFormField ({value, onChange, method, placeholder}) ->

  placeholder ?= 'Bitte Kode auswählen'
  unless method?
    throw new Error "SearchQueryField: property 'method' is required"
  
  [search, setSearch] = useState value
  [selectOptions, setSelectOptions] = useState []

  getSelectOptions = (selectValue) ->
    meteorApply
      method: method
      data: search: selectValue
    .then (result) ->
      unless result.length
        result = [
          value: value
          text: "#{value} [keine Beschreibung vorhanden]"
        ]
      setSelectOptions result
    .catch console.error

  useEffect ->
    setSearch value
    getSelectOptions value
    return
  , [method, value]

  useEffect ->
    getSelectOptions search
    return
  , [search]

  handleSearchChange = (e, d) -> setSearch d.searchQuery
  handleChange = (e, d) ->
    onChange d.value

  <Dropdown
    style={{ minWidth: '12rem' }}
    placeholder={placeholder}
    search
    selection
    fluid
    options={selectOptions}
    onSearchChange={handleSearchChange}
    value={value}
    onChange={handleChange}
  />


