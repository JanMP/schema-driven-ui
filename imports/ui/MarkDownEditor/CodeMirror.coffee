import React, {useEffect, useRef} from 'react'
import cm from 'codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/base16-light.css'
import 'codemirror/mode/markdown/markdown'
import 'cm-show-invisibles'
import _ from 'lodash'


export default CodeMirror = ({value, onChange, options}) ->
  
  options ?=
    mode: 'markdown'
    theme: 'base16-light'
    lineWrapping: true
    tabSize: 2
    showInvisibles: false

  textAreaElement = useRef null
  cmInstance = useRef null

  useEffect ->
    cmInstance.current = cm.fromTextArea textAreaElement.current, options
    cmInstance.current.on "change", ->
      onChange cmInstance.current.getValue()
    return
  , []

  useEffect ->
    return unless value?
    return unless (cmi = cmInstance.current)?
    return if value is cmi.getValue()
    cursor = cmi.getCursor()
    cmi.setValue value
    cmi.setCursor cursor
    return
  , [value]

  handleChange = (event) -> onChange event.target.value

  <textarea
    ref={textAreaElement}
    value={value}
    onChange={handleChange}
    cols="30"
    rows="10"
  />