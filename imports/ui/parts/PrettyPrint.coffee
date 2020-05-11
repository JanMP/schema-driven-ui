import React from 'react'
import { Segment } from 'semantic-ui-react'

export default PrettyPrint = ({value}) ->
  <pre>{JSON.stringify value, null, 2}</pre>
