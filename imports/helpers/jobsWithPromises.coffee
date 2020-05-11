import {Jobs} from 'meteor/msavin:sjobs'

export register = ({name, run}) ->
  Jobs.register "#{name}": (parameters...) -> Promise.await run.apply this, parameters

export run = ({name, data, options}) -> Jobs.run name, data, options