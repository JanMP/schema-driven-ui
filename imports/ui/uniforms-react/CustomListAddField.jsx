import React from 'react';
import classnames from 'classnames';
import cloneDeep from 'lodash/cloneDeep';
import connectField from 'uniforms/connectField';
import filterDOMProps from 'uniforms/filterDOMProps';

/**
 * This has to be the functional way of rendering, because of the option `inlcudeParent` which gets the parents properties automatically.
 * This option can only be specified by the uniforms function connectField. 
 */
const ListAdd = ({ limit, icon, className, disabled, parent, value, ...props }) => {
    const limitNotReached = true;
    if (limit) {
        if (limit <= parent.value.length) {
            limitNotReached = false;
        }
    }

    if (icon) {
        return icon;
    } else {
        return (
            <i
                {...filterDOMProps(props)}
                className={classnames(
                    'ui',
                    className,
                    limitNotReached ? 'link' : 'disabled',
                    'fitted add icon'
                )}
                onClick={() =>
                    limitNotReached &&
                    parent.onChange(parent.value.concat([cloneDeep(value)]))
                }
            />
        );
    }
}

export default connectField(ListAdd, {
    // This option is responsible for the parent, if I set it to false, the parent is not available in this component
    includeParent: true,
    initialValue: false
})


// export default class CustomListAddField extends React.Component {
//     render() {
//         console.log(this.props, this.props.parent.onChange);
//         return (
//             <i />
//         );
//     }
// }