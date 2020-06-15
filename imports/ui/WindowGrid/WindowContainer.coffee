import React from 'react'

export default WindowContainer = ({children, title, key}) ->
  <>
    <div className="window-header" style={userSelect: 'none', cursor: 'move'}>{title}</div>
    <div className="window-content">
      {children}
    </div>
  </>