import React from 'react'

export default WindowContainer = ({children, title, key, noOverflow}) ->

  className = if noOverflow then "window no-overflow" else "window"
  
  <div className={className}>
    <div className="window-header" style={userSelect: 'none', cursor: 'move'}>{title}</div>
    <div className="window-content">
      {children}
    </div>
  </div>