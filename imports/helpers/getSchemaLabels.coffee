import _ from 'lodash'

export default getSchemaLabels = ({schema}) ->
  _.mapValues schema._schema, (key) -> key.label