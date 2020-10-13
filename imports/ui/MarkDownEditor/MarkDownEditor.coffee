import React, {useState, useEffect, useRef} from 'react'
import {Button} from 'semantic-ui-react'
import {Roles} from 'meteor/alanning:roles'
import {useTracker} from 'meteor/react-meteor-data'
import SplitPane from 'react-split-pane'
import AceEditor from 'react-ace'
import useSize from '@react-hook/size'
import useToggle from '@react-hook/toggle'
import {useThrottle} from '@react-hook/throttle'
import MarkDownDisplay from './MarkDownDisplay'
import 'ace-builds/src-noconflict/ext-searchbox'
import 'ace-builds/src-noconflict/mode-markdown'
import 'ace-builds/src-noconflict/theme-chrome'

export default MarkDownEditor = ({value, onChange,
data, contentClass, contentWrapper, toolbar, style, error, disabled, mayEdit = true}) ->

  contentContainerRef = useRef null
  [contentContainerWidth, contentContainerHeight] = useSize contentContainerRef

  editorContainerRef = useRef null
  [editorContainerWidth, editorContainerHeight] = useSize editorContainerRef
  [editorWidth, setEditorWidth] = useThrottle 0
  [editorHeight, setEditorHeight] = useThrottle 0

  markdownDisplayContainerRef = useRef null
  [markdownDisplayContainerWidth, markdownDisplayContainerHeight] = useSize markdownDisplayContainerRef
  [markdownDisplayWidth, setMarkdownDisplayWidth] = useThrottle 0
  [markdownDisplayHeight, setMarkdownDisplayHeight] = useThrottle 0

  [wantsToEdit, toggleWantsToEdit] = useToggle false

  aceComponentRef = useRef null

  useEffect ->
    if (markdownDisplayContainerWidth isnt markdownDisplayWidth) or (markdownDisplayContainerHeight isnt markdownDisplayHeight)
      setMarkdownDisplayWidth markdownDisplayContainerWidth
      setMarkdownDisplayHeight markdownDisplayContainerHeight
    return
  , [markdownDisplayContainerWidth, markdownDisplayContainerHeight]

  useEffect ->
    setEditorWidth contentContainerWidth
    setEditorHeight contentContainerHeight-markdownDisplayContainerHeight
    aceComponentRef?.editor?.reset()
    return
  , [contentContainerWidth, contentContainerHeight, markdownDisplayContainerHeight]
  

  containerStylePresets =
    width: "100%"
    height: "100%"
    backgroundColor: 'white'
    position: 'relative'

  editorContainerStyle =
    width: "100%"
    height: "100%"
    maxHeight: "100%"
    overflow: 'hidden'

  markdownDisplayContainerStyle =
    width: "100%"
    height: "100%"
    overflow: "auto"
    borderBottom: if mayEdit then "1px solid silver" else "none"

  errorStyle =
    if error
      border: '1pt solid #e0b4b4'
    else {}

  containerStyleWithPresets = {containerStylePresets..., style..., errorStyle...}
  
  editorDisplay =
    <div ref={editorContainerRef} style={editorContainerStyle}>
      <AceEditor
        ref={aceComponentRef}
        mode="markdown"
        theme="chrome"
        width={editorWidth}
        height={editorHeight}
        value={value}
        onChange={onChange}
        setOptions={wrap: true, showInvisibles: true}
      />
    </div>

  markdownDisplay =
    <div ref={markdownDisplayContainerRef} style={markdownDisplayContainerStyle}>
      <MarkDownDisplay
        markdown={value}
        data={data}
        helpWithData={true}
        contentClass={contentClass}
        contentWrapper={contentWrapper}
      />
    </div>

  toolbar ?= <div style={borderTop: '1pt solid silver', flex: '0 0 20px'} />

  <div style={height: '100%', width: '100%', display: 'flex', flexDirection: 'column'}>
    <div ref={contentContainerRef} style={containerStyleWithPresets}>
      {
        if mayEdit
          <SplitPane
            split='horizontal'
            minSize={0}
            maxSize={contentContainerHeight}
            defaultSize={contentContainerHeight}
            style={height: '100%', width: '100%', position: 'absolute'}
          >
            {markdownDisplay}
            {editorDisplay}
          </SplitPane>
        else
          markdownDisplay
      }
    </div>
    {toolbar}
  </div>
    
