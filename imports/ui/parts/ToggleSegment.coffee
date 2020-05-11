import React, {useState} from 'react'
import {Header, Segment} from 'semantic-ui-react'
 

export default ToggleSegment = ({title, wrapperStyle, headerStyle, segmentStyle, children}) ->

  [show, setShow] = useState true
  toggle = -> setShow not show

  wrapperStylePresets =
    boxShadow: '0px 6px 8px rgba(2,27,59,0.08)'
    marginBottom: '1.2rem'

  wrapperStyleWithPresets = {wrapperStylePresets..., wrapperStyle...}

  headerStylePresets =
    userSelect: 'none'
    cursor: 'ns-resize'
    height: '60px'
    borderBottom: 'none'
    paddingTop: '16px'

  headerStylewithPresets = {headerStylePresets..., headerStyle...}

  <div style={wrapperStyleWithPresets}>
    <Header as="h3" attached="top" onClick={toggle} style={headerStylewithPresets}>{title ? '[kein Titel angegeben]'}</Header>
    {if show then <Segment attached style={segmentStyle}>{children}</Segment>}
  </div>