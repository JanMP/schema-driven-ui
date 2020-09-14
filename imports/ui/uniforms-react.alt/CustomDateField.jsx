import React from 'react';
import CustomBaseField from './CustomBaseField';
import { DateInput } from 'semantic-ui-calendar-react';
import moment from 'moment';
import classnames from 'classnames';

export default class CustomDateField extends CustomBaseField {
    constructor(props) {
        super(props);

        this.state = {
            placeholder: 'Select a date',
            format: 'YYYY-MM-DD'
        }
    }

    onChange(event, data) {
        let formattedDate = new Date(data.value);
        this.props.onChange(formattedDate);
        this.setState({ date: data.value });
    }

    renderDateInput() {
        return (
            <DateInput
                {...this.getFilteredProps()}
                placeholder={this.props.placeholder || this.state.placeholder}
                value={moment(this.props.value).format('YYYY-MM-DD')}
                dateFormat={this.state.format}
                onChange={(event, data) => { this.onChange(event, data) }}
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
                {this.renderPopup(this.renderDateInput())}
                {this.renderInlineError()}
            </div>
        );
    }
}