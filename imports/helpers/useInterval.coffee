import React, {useState, useEffect, useRef} from 'react'


export default useInterval = ({callback, delay}) ->
  savedCallback = useRef()

  useEffect ->
    savedCallback.current = callback
  , [callback]

  useEffect ->
    if delay?
      id = setInterval savedCallback.current, delay
      -> clearInterval id #cleanup
  , [delay]