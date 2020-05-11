import SimpleSchema from 'simpl-schema'
import ActiveToggleField from '/imports/ui/parts/ActiveToggle'
import _ from 'lodash'

activeToggleSchemaDefinition=
  activeToggle:
    label: 'Aktiv'
    type: Boolean
    defaultValue: true
    optional: true
    uniforms: ActiveToggleField

export activeToggleSchema = new SimpleSchema activeToggleSchemaDefinition

export schemaWithActiveToggle = ({schema}) -> (_.cloneDeep schema).extend activeToggleSchema

export schemaDefinitionWithActiveToggle = ({definition}) -> {definition..., activeToggleSchemaDefinition...}
