import React from 'react'
import QueryEditor from './QueryEditor'
import connectWithFormField from '../parts/connectWithFormField'
import _ from 'lodash'

export default QueryEditorField = connectWithFormField ({value, onChange, schema, path}) ->
  
  rule = value unless _.isEqual value, {}
  
  <QueryEditor {{rule, onChange, schema, path}...}/>
