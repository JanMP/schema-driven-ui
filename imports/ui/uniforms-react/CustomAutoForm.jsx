import PropTypes from 'prop-types';

import merge from 'lodash/merge';
import omit from 'lodash/omit';

import AutoForm from 'uniforms-semantic/AutoForm';

import {
    __childContextTypes,
    __childContextTypesBuild
} from 'uniforms/BaseForm';

const childContextTypes = __childContextTypesBuild(
    merge(
        { state: { readOnly: PropTypes.bool.isRequired } },
        __childContextTypes
    )
);

const CustomAuto = parent =>
    class extends parent {
        static CustomAuto = CustomAuto;
        static displayName = `Custom${parent.displayName}`;

        static childContextTypes = {
            ...(parent.childContextTypes || {}),
            uniforms: childContextTypes
        }

        constructor() {
            super(...arguments);
            this.state = {
                ...this.state,

                readOnly: !!this.props.readOnly
            }
        }

        getNativeFormProps() {
            let nativeProps = super.getNativeFormProps();
            if (this.state.readOnly) {
                nativeProps = omit(super.getNativeFormProps(), [
                    'onChangeModel'
                ]);
            }
            return nativeProps;
        }

        getChildContextState() {
            return {
                ...super.getChildContextState(),

                readOnly: this.state.readOnly
            };
        }
    };


export default CustomAuto(AutoForm);