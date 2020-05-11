import { createElement } from 'react';
import invariant from 'invariant';
import moment from 'moment';

import BaseField from 'uniforms/BaseField'
import { RadioField, ListField, NumField, BoolField, TextField } from 'uniforms-semantic';

import CustomNestField from './CustomNestField';
import CustomSelectField from './CustomSelectField';
import CustomDateField from './CustomDateField';
import ReadOnlyField from './ReadOnlyField';
import CustomTextField from './CustomTextField';
import CustomListField from './CustomListField';



export default class CustomAutoField extends BaseField {

    static displayName = 'CustomAutoField';

    getChildContextName() {
        return this.context.uniforms.name;
    }

    // Determine which Element to load and return for the form to display
    determineComponentFromProps(props) {
        if (props.readOnly || (props.field.uniforms && props.field.uniforms.readOnly)) {
            switch (props.fieldType) {
                case Object:
                    props.component = CustomNestField;
                    break;
                case Array:
                    props.component = CustomListField;
                    break;
                case Date:
                    let date = props.value;
                    props.value = moment(date).format('YYYY-MM-DD');
                    props.component = ReadOnlyField;
                    break;
                default:
                    props.component = ReadOnlyField;
                    break;
            }
        }
        if (props.component === undefined) {
            if (props.allowedValues) {
                if (props.checkboxes && props.fieldType !== Array) {
                    props.component = RadioField;
                } else {
                    props.component = CustomSelectField;
                }
            } else {
                // Meckert rum wegen no default case, wird aber hier nicht gebraucht
                // eslint-disable-next-line
                switch (props.fieldType) {
                    case Date:
                        props.component = CustomDateField;
                        break;
                    case Array:
                        props.component = CustomListField;
                        break;
                    case Number:
                        props.component = NumField;
                        break;
                    case Object:
                        props.component = CustomNestField;
                        break;
                    case String:
                        props.component = TextField;
                        break;
                    case Boolean:
                        props.component = BoolField;
                        break;
                }

                invariant(
                    props.component,
                    'Unsupported field type: %s',
                    props.fieldType.toString()
                );
            }
        }

        return props.component;
    }

    render() {
        const props = this.getFieldProps(undefined, { ensureValue: false });
        let component = this.determineComponentFromProps(props);

        let element = createElement(component, props);
        return element;
    }
}