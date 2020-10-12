import React from 'react';
import joinName from 'uniforms/joinName';
import injectName from 'uniforms/injectName';
import classnames from 'classnames';

import CustomBaseField from './CustomBaseField';

import CustomAutoField from './CustomAutoField';


export default class CustomNestField extends CustomBaseField {
    renderNestedField() {
        let name = this.props.name;
        let children = this.props.children;


        let fields;
        if (children) {
            fields = injectName(name, children);
        } else {
            fields = this.props.fields.map((key) => {
                return (
                    <CustomAutoField key={key} name={joinName(name, key)} readOnly={this.props.readOnly} {...this.props.itemProps}></CustomAutoField>
                );
            });
        }

        return fields;
    }

    renderLabel() {
        return (
            <div className="field">
                <label>{this.props.label}</label>
            </div>
        );
    }

    renderError() {
        return (
            <div className="ui red basic label">{this.props.errorMessage}</div>
        );
    }

    render() {
        let disabled = this.props.disabled;
        let error = this.props.error;
        let required = this.props.required;
        return (
            <div className={classnames(this.props.className, { disabled, error, required }, 'field')}>
                {this.props.label && this.renderLabel()}
                {this.props.error && this.props.showInlineError && this.renderError()}
                {this.renderNestedField()}
            </div>
        );
    }
}