import React from 'react';

import classnames from 'classnames';

import CustomBaseField from './CustomBaseField';
import CustomAutoField from './CustomAutoField';
import CustomListAddField from './CustomListAddField';
import CustomListItemField from './CustomListItemField';



import { ListAddField, ListItemField } from 'uniforms';
import filterDOMProps from 'uniforms/filterDOMProps';
import joinName from 'uniforms/joinName';
import injectName from 'uniforms/injectName';

export default class CustomListField extends CustomBaseField {
    constructor(props) {
        super(props);

        let count = 0;
        if (this.props.value) {
            count = this.props.value.length;
        }
        this.state = {
            initialCount: count
        };
    }

    renderListField() {
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

    renderIcon() {
        if (!this.props.readOnly) {
            return <CustomListAddField name={`${this.props.name}.$`} className="right floated" icon={this.props.addIcon} />
        }
    }


    render() {
        let disabled = this.props.disabled;
        let error = this.props.error;
        let required = this.props.required;
        return (
            <div
                className={classnames(
                    'ui',
                    this.props.className,
                    { disabled },
                    'grouped fitted fields list'
                )}
                {...filterDOMProps(this.props)}
            >
                {this.props.label && (
                    <div className={classnames({ error, required }, 'field item')}>
                        <label className="left floated">{this.props.label}</label>
                        {this.renderIcon()}
                    </div>
                )}

                {this.props.label && <div className="ui fitted hidden clearing horizontal divider" />}

                {!!(error && this.props.showInlineError) && (
                    <div className="ui red basic label">{this.props.errorMessage}</div>
                )}

                {this.props.children
                    ? this.props.value.map((item, index) =>
                        React.Children.map(this.props.children, child =>
                            React.cloneElement(child, {
                                key: index,
                                label: null,
                                name: joinName(
                                    this.props.name,
                                    child.props.name && child.props.name.replace('$', index)
                                )
                            })
                        )
                    )
                    : this.props.value.map((item, index) => {
                        return (
                            <CustomListItemField
                                key={index}
                                label={null}
                                name={joinName(this.props.name, index)}
                                icon={this.props.deleteIcon}
                                readOnly={this.props.readOnly}
                            />
                        );
                    })}
            </div>

        );
    }
}