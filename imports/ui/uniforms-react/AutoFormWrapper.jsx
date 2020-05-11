import React from 'react';

// import AutoForm from 'uniforms/AutoForm';
import AutoForm from './CustomAutoForm';
import CustomAutoField from './CustomAutoField';

import { omit } from 'lodash';


export default class AutoFormWrapper extends React.Component {
    render() {
        return (
            <AutoForm
                {...(omit(this.props, ['setRef']))}
                ref={this.props.setRef}
                autoField={CustomAutoField}
            >
                {this.props.children}
            </AutoForm>
        );
    }
}