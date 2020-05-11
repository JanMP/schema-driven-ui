import React from 'react';

import { Popup } from 'semantic-ui-react';
import filterDOMProps from 'uniforms/filterDOMProps';


export default class CustomBaseField extends React.Component {
    getFilteredProps() {
        return filterDOMProps(this.props);
    }

    /**
     * Notfies the parent component that a selection has been made.
     * @param {*} event 
     * @param {*} data 
     */
    onChange(event, data) {
        let value = data.value;
        this.props.onChange(value);
        this.setState({
            value: data.value
        });
    }

    /**
     * Renders the label
     */
    renderLabel() {
        return (
            <label htmlFor={this.props.name}>{this.props.label}</label>
        );
    }

    /**
     * If the prop is set, it renders the error as an inline element.
     */
    renderInlineError() {
        if (this.props.error && this.props.disablePopup && this.props.showInlineError) {
            return (<div className="ui red basic pointing label">{this.props.errorMessage}</div>);
        }
    }

    /**
     * Popup displays errors when hovered over the marked InputField.
     */
    renderPopup(trigger) {
        if (!this.props.disablePopup) {
            return (
                <Popup content={this.props.errorMessage}
                    position="top left"
                    disabled={!this.props.error}
                    trigger={trigger}
                />
            );
        } else {
            return trigger;
        }
    }
}
