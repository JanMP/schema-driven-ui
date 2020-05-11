import React from 'react'
import {connectField} from 'uniforms'
import {Form, Popup} from 'semantic-ui-react'
import _ from 'lodash'

export default connectWithFormField = (component) -> connectField (props) ->

  {disabled, error, inline, required} = props

  <Form.Field {{disabled, error, inline, required}...}>
    {if props.label then <label htmlFor={props.name}>{props.label}</label>}
    {component props}
  </Form.Field>