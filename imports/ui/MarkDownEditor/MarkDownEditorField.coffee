import React from 'react'
import connectWithFormField from '../parts/connectWithFormField'
import {connectField} from 'uniforms'
import MarkDownEditor from './MarkDownEditor'

export default MarkDownEditorField = connectWithFormField ({value, onChange, style, contentClass, error, disabled}) ->
  
  stylePresets =
    height: "10rem"
    border: '1px solid #e4e4e4'
    borderRadius: '2px'

  styleWithPresets = {stylePresets..., style...}

  <MarkDownEditor {{value, onChange, contentClass, error, disabled, style: styleWithPresets}...}/>