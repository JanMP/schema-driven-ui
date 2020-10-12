import SimpleSchema from 'simpl-schema';
import SimpleSchema2Bridge from 'uniforms-bridge-simple-schema-2';

import CustomAutoField from '../uniforms-react/AutoField';
import CustomDateTimeField from '../uniforms-react/CustomDateTimeField';

let guestSchemaDefinition = {
    // 'firstName': {
    //     type: String,
    // },
    // 'lastName': {
    //     type: String
    // },
    // 'workExperience': {
    //     type: Number,
    // },
    // 'jobType': {
    //     type: String,
    //     allowedValues: ['Management', 'IT', 'Finance', 'HR', 'Engineering']
    // },
    'customJobType': {
        type: String,
        allowedValues: ['Management', 'IT', 'Finance', 'HR', 'Engineering'],
        uniforms: {
            itemprops: {
                component: CustomAutoField,
                customType: "Select"
            }
        }
    },
    'dateTime': {
        type: String,
        uniforms: {
            itemprops: {
                component: CustomDateTimeField,
                customType: "DateTime"
            }
        }
    }
};
const GuestSimpleSchema = new SimpleSchema(guestSchemaDefinition);
const bridge = new SimpleSchema2Bridge(GuestSimpleSchema);
export default bridge;