import React, {useState} from 'react'
import GridLayout, {WidthProvider} from 'react-grid-layout'

Grid = WidthProvider GridLayout

export default WindowGrid = ({name, children, defaultLayout}) ->

  unless name?
    throw new Error 'WindowGrid: name prop is required'

  content = React.Children.map children, (child) -> <div className="window" key={child.props.key}>{child}</div>

  getLayoutFromLocalStorage = ->
    if global.localStorage
      try
        JSON.parse(global.localStorage.getItem name)?.layout
      catch error
        console.error error

  saveLayoutToLocalStorage = (layout) ->
    if global.localStorage
      global.localStorage.setItem name, JSON.stringify {layout}

  [layout, setLayout] = useState getLayoutFromLocalStorage ? defaultLayout

  onLayoutChange = (layout) ->
    setLayout layout
    saveLayoutToLocalStorage layout

  <Grid
    style={poistion: 'relative'}
    className="layout"
    onLayoutChange={onLayoutChange}
    layout={layout}
    draggableHandle=".window-header"
    cols={12} rowHeight={30}
  >
    {content}
  </Grid>