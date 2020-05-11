import {BaseField, connectField} from 'uniforms'

# class TransparentBaseField extends BaseField
#   shouldComponentUpdate: -> true

export default connectFieldWithContext = (component) ->
  component.contextTypes = BaseField.contextTypes
  connectField component #, baseField: TransparentBaseField