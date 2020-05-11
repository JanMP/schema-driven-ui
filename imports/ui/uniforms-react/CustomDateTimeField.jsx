import React from 'react';
import { DateTimeInput } from 'semantic-ui-calendar-react';
import moment from 'moment';
import classnames from 'classnames';
import CustomBaseField from './CustomBaseField';


export default class CustomDateTimeField extends CustomBaseField {
    constructor(props) {
        super(props);

        this.state = {
            defaultFormat: 'YYYYMMDDHHmm',
            defaultDateFormat: 'YYYY-MM-DD',
            defaultTimeFormat: '24',
            placeholder: "Select a date and time"
        };
    }
    /**
     * Notfies the parent component that a selection has been made.
     * 
     * Needs to be overwritten, because the value in the state is used to display value changes in the component.
     * 
     * @param {*} event 
     * @param {*} data 
     */
    onChange(event, data) {
        let formattedDateTime = moment(data.value).format(this.props.format || this.state.defaultFormat);
        this.props.onChange(formattedDateTime);
    }

    renderDateTimeInput() {
        return (
            <DateTimeInput
                {...this.getFilteredProps()}
                placeholder={this.props.placeholder || this.state.placeholder}
                value={moment(this.props.value).format('YYYYMMDDHHmm')}
                onChange={(event, data) => { this.onChange(event, data) }}
                dateFormat={this.props.dateFormat || this.state.defaultDateFormat}
                timeFormat={this.props.timeFormat || this.state.defaultTimeFormat}
            />
        );
    }

    render() {
        let disabled = this.props.disabled;
        let error = this.props.error;
        let required = this.props.required;
        return (
            <div
                {...this.getFilteredProps()}
                className={classnames(this.props.className, { disabled, error, required }, 'field')}
            >
                {this.props.label && this.renderLabel()}
                {this.renderPopup(this.renderDateTimeInput())}
                {this.renderInlineError()}
            </div>
        );
    }
}