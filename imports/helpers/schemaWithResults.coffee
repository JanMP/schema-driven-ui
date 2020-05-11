import SimpleSchema from 'simpl-schema'
import _ from 'lodash'

resultsSchemaDefinition = (resultField) ->
  results:
    type: Object
    blackbox: true
    defaultValue: {}
    optional: true
    uniforms: resultField

export resultsSchema = (resultField) -> new SimpleSchema resultsSchemaDefinition resultField

export schemaWithResults = ({schema, resultField}) -> (_.cloneDeep schema).extend resultsSchema resultField

export schemaDefinitionWithResults =
  ({definition, resultField}) -> {definition..., (resultsSchemaDefinition resultField)...}
