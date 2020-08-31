import React from "react";
import {
    useDigitFormField,
    DigitTextField,
    DigitForm,
    DigitLayout,
    DigitButton,
    DigitDateAndTimePicker,
} from "@cthit/react-digit-components";
import * as yup from "yup";

const Title = () => {
    const titleValues = useDigitFormField("title");
    return <DigitTextField {...titleValues} upperLabel="Titel" />;
};

const phoneRegExp = /^((\\+[1-9]{1,4}[ \\-]*)|(\\([0-9]{2,3}\\)[ \\-]*)|([0-9]{2,4})[ \\-]*)*?[0-9]{3,4}?[ \\-]*[0-9]{3,4}?$/;
const PhoneNumber = ({ name, label }) => {
    const phoneValues = useDigitFormField(name);
    return <DigitTextField {...phoneValues} upperLabel={label} />;
};

const TimePicker = ({ name, label }) => {
    const timeValues = useDigitFormField(name);
    return <DigitDateAndTimePicker {...timeValues} upperLabel={label} />;
};

const validationSchema = yup.object().shape({
    title: yup.string().required(),
    phone: yup.string().matches(phoneRegExp),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
});

const NewReservationFrom = ({ onSubmit }) => {
    return (
        <DigitForm
            initialValues={{
                title: "",
                phone: "",
                begin_date: new Date(),
                end_date: new Date(),
            }}
            validationSchema={validationSchema}
            onSubmit={values => {
                validationSchema
                    .validate(values)
                    .then(() => onSubmit(values))
                    .catch(err => console.log(err));
            }}
            render={() => (
                <DigitLayout.Column>
                    <Title />
                    <PhoneNumber name="phone" label="Telefonnummer" />
                    <DigitLayout.Row>
                        {/**
                            //TODO: Can not find utils in context. You either a) forgot to wrap your component tree in MuiPickersUtilsProvider; or b) mixed named and direct file imports.  Recommendation: use named imports from the module index.
                            <TimePicker name="begin_date" label="Startdatum" />
                            <TimePicker name="end_date" label="Slutdatum" />
                         */}
                    </DigitLayout.Row>
                    <DigitButton raised submit text="Submit" />
                </DigitLayout.Column>
            )}
        />
    );
};

export default NewReservationFrom;
