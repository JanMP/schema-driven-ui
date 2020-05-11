export default withTiming = (label, fkt) ->
  (args...) ->
    start = Date.now()
    result = fkt args...
    data = {executionTime: "#{Date.now() - start} ms", args, result}
    console.log label, data
    result
