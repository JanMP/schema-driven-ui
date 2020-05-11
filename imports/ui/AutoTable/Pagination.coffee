# A small custom Pagination with limited props and callback, that's designed
# to not allow the user to jump to the last pages (since proper sorting takes
# a bit long for really high number pages)

import React, {useState} from 'react'
import  {Button} from 'semantic-ui-react'

e = {}
d = {}

export default Pagination = ({activePage, totalPages, onPageChange}) ->
  
  decreasePage = ->
    if activePage > 1
      d.activePage = activePage - 1
      onPageChange e, d

  increasePage = ->
    if activePage < totalPages
      d.activePage = activePage + 1
      onPageChange e, d

  displayString =
    "#{activePage}/#{if totalPages < 10 then ' ' else ''}#{totalPages}"
  
  <Button.Group basic>
    <Button icon="angle left" onClick={decreasePage}/>
    <Button>{displayString}</Button>
    <Button icon="angle right" onClick={increasePage}/>
  </Button.Group>
