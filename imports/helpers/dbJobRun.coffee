import {Jobs} from 'meteor/msavin:sjobs'

export default dbJobRun = ({name, data, options}) ->
  data ?= {}
  Jobs.run 'dbJob', {name, data}, options