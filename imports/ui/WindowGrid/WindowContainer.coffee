import React from 'react'

export default WindowContainer = ({children, title, key}) ->
  <>
    <div className="window-header">{title}</div>
    <div className="window-content">
      {children}
    </div>
  </>