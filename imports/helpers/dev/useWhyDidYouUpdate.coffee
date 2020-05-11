import React, {useEffect, useRef} from 'react'
import _ from 'lodash'

export default useWhyDidYouUpdate = (name, props) ->
  
  previousProps = useRef()

  useEffect ->
    if previousProps.current
      allKeys = _.keys {previousProps.current..., props...}
      changesObj = {}
      allKeys.forEach (key) ->
        if previousProps.current[key] isnt props[key]
          changesObj[key] =
            from:  previousProps.current[key]
            to: props[key]
      if _(changesObj).keys().value().length
        console.log '[why-did-you-update]', name, changesObj
    previousProps.current = props
    return
    