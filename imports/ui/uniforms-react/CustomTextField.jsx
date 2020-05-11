import React from 'react';
import CustomBaseField from './CustomBaseField';
import classnames from 'classnames';

import { Input } from 'semantic-ui-react';

export default class CustomTextField extends CustomBaseField {
    constructor(props) {
        super(props);

        this.state = {
            placeholder: this.props.placeholder || '',
        };
    }

    renderInput() {
        return (
            <Input
                {...this.getFilteredProps()}
                value={this.props.value}
                placeholder={this.state.placeholder}
                onChange={(e, d) => this.onChange(e, d)}
                type={this.props.type || 'text'}
            />
        );
    }

    render() {
        let disabled = this.props.disabled;
        let error = this.props.error;
        let required = this.props.required;
        return (
            <div className={classnames(this.props.className, { disabled, error, required }, 'field')}>
                {this.props.label && this.renderLabel()}
                {this.renderPopup(this.renderInput())}
            </div>
        );
    }
}