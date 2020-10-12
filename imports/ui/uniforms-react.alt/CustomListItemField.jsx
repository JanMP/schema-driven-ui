import React, { Children } from 'react';
import {connectField} from 'uniforms';
import joinName from 'uniforms/joinName';


import CustomAutoField from './CustomAutoField';
import CustomListDelField from './CustomListDelField';

const CustomListItem = props => {
    return (
        <div className="item">
            {!props.readOnly && <CustomListDelField className="top aligned" name={props.name} icon={props.icon} />}

            <div className="middle aligned content" style={{ width: '100%' }}>
                {props.children ? (
                    Children.map(props.children, child =>
                        React.cloneElement(child, {
                            name: joinName(props.name, child.props.name),
                            label: null,
                            style: {
                                margin: 0,
                                ...child.props.style
                            }
                        })
                    )
                ) :
                    (<CustomAutoField {...props} style={{ margin: 0 }} />)
                }
            </div>
        </div>
    );
}

export default connectField(CustomListItem, {
    includeParent: true,
    includeInChain: false
});