import _ from 'lodash'

export predicates =
  $eq: '='
  $ne: '<>'
  $gt: '>'
  $gte: '>='
  $lt: '<'
  $lte: '<='
  $regex: '~'
  $in: 'in'
  $nin: 'nicht in'

export predicateSelectOptions =
  _(predicates)
  .keys()
  .map (key) ->
    value: key
    text: predicates[key]
  .value()
