import React from 'react';
import { Dropdown } from 'semantic-ui-react';
import CustomBaseField from './CustomBaseField';
import classnames from 'classnames';

export default class CustomSelectField extends CustomBaseField {
    constructor(props) {
        super(props);

        this.state = {
            placeholder: this.props.placeholder || ''
        };
    }

    /**
     * Gets the value options from the properties so that they can be displyed with the Dropdown Component.
     */
    getOptions() {
        let allowedValues = this.props.allowedValues;
        let count = allowedValues.length;
        let options = [];
        for (let i = 0; i < count; i++) {
            let currentValue = allowedValues[i];
            options[i] = { key: currentValue, text: currentValue, value: currentValue };
        }

        return options;
    }

    /**
     * Returns the dropdown, that is displayed in the form.
     * This is the main component.
     * It is displayed with the trigger of the Popup Component so that the Popup is displayed in the correct position.
     * 
     */
    renderDropdown() {
        return (
            <Dropdown
                {...this.getFilteredProps()}
                // Alle Props die nicht angepasst werden so übergeben, die die ich anpassen muss danach damit die Werte aus den eigentlich Props überschrieben werden.
                // So können auch die Props die semantic-ui-react hat, verwendet werden
                id={this.props.id}
                name={this.props.name}
                labeled
                placeholder={this.state.placeholder}
                disabled={this.state.disabled || this.props.disabled}
                fluid
                selection
                value={this.props.value}
                options={this.getOptions()}
                onChange={(event, data) => { this.onChange(event, data) }}
            />
        );
    }

    /**
     * Displays the whole component.
     * See renderDropdown() for the main component.
     */
    render() {
        let disabled = this.props.disabled;
        let error = this.props.error;
        let required = this.props.required;
        return (
            <div className={classnames(this.props.className, { disabled, error, required }, 'field')}>
                {this.props.label && this.renderLabel()}
                {this.renderPopup(this.renderDropdown())}
                {this.renderInlineError()}
            </div>
        );
    }
}