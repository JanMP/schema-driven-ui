import React from 'react';
import CustomBaseField from './CustomBaseField';


import classnames from 'classnames';

export default class ReadOnlyField extends CustomBaseField {
    constructor(props) {
        super(props);
        this.state = {
            value: this.props.value || '',
        };
    }


    componentDidUpdate() {
        if (this.props.value !== this.state.value) {
            this.setState({
                value: this.props.value
            })
        }
    }


    render() {
        return (
            <div
                {...this.getFilteredProps()}
                className={classnames(this.props.className, 'field')}
                style={this.props.style}
            >
                {this.props.label && this.renderLabel()}
                <p style={{marginLeft: '.5rem', fontSize: '90%'}}>{this.state.value}</p>
            </div>
        );
    }
}