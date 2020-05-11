import React from 'react';
import CustomBaseField from './CustomBaseField';

import { Input } from 'semantic-ui-react';

import classnames from 'classnames';

export default class DisabledField extends CustomBaseField {
    renderInputField() {
        return (
            <Input
                {...this.getFilteredProps()}
                disabled
                placeholder={this.props.placeholder}
                value={this.props.value}
            />
        );
    }

    render() {
        let disabled = true;
        return (
            <div
                {...this.getFilteredProps(this.props)}
                className={classnames(this.props.className, { disabled }, 'field')}
            >
                {this.props.label && this.renderLabel()}
                {this.renderInputField()}
            </div>
        );
    }
}