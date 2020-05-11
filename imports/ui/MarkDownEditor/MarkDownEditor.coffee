import React, {useState, useEffect} from 'react'
import {Segment} from 'semantic-ui-react'
import {Roles} from 'meteor/alanning:roles'
import {useTracker} from 'meteor/react-meteor-data'

import Splitter from 'm-react-splitters'
import 'm-react-splitters/lib/splitters.css'

import CodeMirror from './CodeMirror'
import './customCodemirror.styl'

import MarkDownDisplay from './MarkDownDisplay'

export default MarkDownEditor = ({value, onChange, data, contentClass, contentWrapper,  style, error, disabled, mayEdit = true}) ->
  
  [editorPaneWidth, setEditorPaneWidth] = useState 0

  containerStylePresets =
    width: "100%"
    height: "100%"
    backgroundColor: 'white'

  contentStylePresets =
    width: "100%"
    overflowY: 'auto'

  errorStyle =
    if error
      border: '1pt solid #e0b4b4'
    else {}
  
  maxWidth = if disabled then '0%' else '100%'

  containerStyleWithPresets = {containerStylePresets..., style..., errorStyle...}
  
  markdownDisplay =
    <MarkDownDisplay
      markdown={value}
      data={data}
      helpWithData={true}
      style={height: "100%", overflowY: 'auto'}
      contentClass={contentClass}
      contentWrapper={contentWrapper}
    />

  <div style={containerStyleWithPresets}>
    {
      if mayEdit
        <Splitter
          style={height: "100%"}
          position="vertical"
          primaryPaneMinWidth={0}
          primaryPaneMaxWidth={maxWidth}
          primaryPaneWidth={0}
        >
          <CodeMirror
            value={value}
            onChange={onChange}
          />
          {markdownDisplay}
        </Splitter>
      else
        markdownDisplay
    }
    
  </div>
