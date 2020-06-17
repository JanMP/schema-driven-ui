import React, {useState, useEffect, useRef} from 'react'
import {Segment} from 'semantic-ui-react'
import {Roles} from 'meteor/alanning:roles'
import {useTracker} from 'meteor/react-meteor-data'
import AceEditor from 'react-ace'
import SplitPane from 'react-split-pane'
import useSize from '@react-hook/size'
import {useThrottle} from '@react-hook/throttle'
import MarkDownDisplay from './MarkDownDisplay'

export default MarkDownEditor = ({value, onChange,
data, contentClass, contentWrapper,  style, error, disabled, mayEdit = true}) ->

  editorContainerRef = useRef null
  aceComponentRef = useRef null

  [editorContainerWidth, editorContainerHeight] = useSize editorContainerRef
  [editorWidth, setEditorWidth] = useThrottle 0
  [editorHeight, setEditorHeight] = useThrottle 0

  useEffect ->
    if (editorContainerWidth isnt editorWidth) or (editorContainerHeight isnt editorHeight)
      setEditorWidth editorContainerWidth
      setEditorHeight editorContainerHeight
      aceComponentRef?.editor?.reset()
    return
  , [editorContainerWidth, editorContainerHeight]

  containerStylePresets =
    width: "100%"
    height: "100%"
    backgroundColor: 'white'
    position: "relative"

  contentStylePresets =
    width: "100%"
    overflowY: 'auto'

  errorStyle =
    if error
      border: '1pt solid #e0b4b4'
    else {}
  
  maxWidth = if disabled then '0%' else '100%'

  containerStyleWithPresets = {containerStylePresets..., style..., errorStyle...}
  
  editorDisplay =
    <div ref={editorContainerRef} style={width: "100%", height: "100%"}>
      <AceEditor
        ref={aceComponentRef}
        mode="markdown"
        theme="kuroir"
        height={editorHeight}
        width="100%"
        value={value}
        onChange={onChange}
      />
    </div>

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
        <SplitPane
          split="horizontal"
          defaultSize="50%"
          primary="second"
        >
          {markdownDisplay}
          {editorDisplay}
        </SplitPane>
      else
        markdownDisplay
    }
  </div>
    
