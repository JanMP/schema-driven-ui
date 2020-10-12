import React from 'react';

import CustomBaseField from './CustomBaseField';
import classnames from 'classnames';
import TextAreaAutosize from 'react-textarea-autosize';


export default class CustomTextArea extends CustomBaseField {
    constructor(props) {
        super(props);

        this.state = {
            value: this.props.value || '',
            placeholder: this.props.placeholder || 'Enter a text'
        }
    }

    /**
     * Custom onChange, because the value is emitted differently than the other fields.
     * @param {*} e 
     * @param {*} d 
     */
    onChange(e, d) {
        let value = e.target.value;
        this.props.onChange(value);
    }

    renderTextArea() {
        return (
            <TextAreaAutosize
                {...this.getFilteredProps()}
                placeholder={this.state.placeholder}
                value={this.props.value}
                onChange={(e, d) => this.onChange(e, d)}
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
                {this.renderPopup(this.renderTextArea())}
                {this.props.inlineError && this.renderInlineError()}
            </div>
        );
    }
};