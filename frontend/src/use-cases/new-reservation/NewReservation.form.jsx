import React from "react";
import {
    useDigitFormField,
    DigitTextField,
    DigitForm,
    DigitLayout,
    DigitButton,
    DigitDateAndTimePicker,
    DigitTextArea,
    DigitSelect,
    useDigitFormFieldArray,
    //DigitRadioButtonGroup,
} from "@cthit/react-digit-components";
import * as yup from "yup";
import PropTypes from "prop-types";

const Title = () => {
    const titleValues = useDigitFormField("title");
    return <DigitTextField {...titleValues} upperLabel="Titel" />;
};

const PhoneNumber = ({ name, label }) => {
    const phoneValues = useDigitFormField(name);
    return <DigitTextField {...phoneValues} upperLabel={label} />;
};

//TODO: Uncomment when PR #423 is merged in RDC
/*const Rooms = ({ rooms }) => {
    const roomValues = useDigitFormField("room");
    return (
        <DigitRadioButtonGroup
            {...roomValues}
            upperLabel="Lokal"
            radioButtons={rooms.map(room => {
                return { ...room, primary: true };
            })}
        />
    );
};*/

const TimePicker = ({ name, label }) => {
    const timeValues = useDigitFormField(name);
    return <DigitDateAndTimePicker {...timeValues} upperLabel={label} />;
};

const BookAs = ({ groups }) => {
    const dropDownValues = useDigitFormField("bookAs");
    const getGroups = () => {
        const groupObject = {};
        for (var i = 0; i < groups.length; i++)
            groupObject[groups[i]] = groups[i];
        return groupObject;
    };
    return (
        <DigitSelect
            {...dropDownValues}
            upperLabel="Boka som"
            valueToTextMap={getGroups()}
        />
    );
};

BookAs.propTypes = {
    groups: PropTypes.arrayOf(PropTypes.string),
};

const Description = () => {
    const descriptionValues = useDigitFormField("description");
    return (
        <DigitTextArea
            size={{ width: "100%" }}
            rows={5}
            rowsMax={8}
            {...descriptionValues}
            upperLabel="Beskrivning"
        />
    );
};

const validationSchema = yup.object().shape({
    title: yup.string().required(),
    phone: yup.string().required(),
    //room: yup.string().required(),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
    bookAs: yup.string().required(),
    /*is_activity: yup.bool(),
    activity_contact_number: yup.lazy(({ is_activity }) =>
        is_activity ? yup.string() : yup.string().required()
    ),*/
});

const NewReservationFrom = ({ onSubmit }) => {
    return (
        <DigitForm
            initialValues={{
                title: "",
                phone: "",
                //room: "hubben",
                begin_date: new Date(),
                end_date: new Date(),
                /*is_activity: false,
                activity_contact_number: "",*/
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
                    {/*<Rooms
                        rooms={[
                            {
                                id: "hubben",
                                label: "Hubben",
                            },
                            {
                                id: "grupprummet",
                                label: "Grupprummet",
                            },
                        ]}
                    />*/}
                    <DigitLayout.Row>
                        <TimePicker name="begin_date" label="Startdatum" />
                        <TimePicker name="end_date" label="Slutdatum" />
                    </DigitLayout.Row>
                    <Description />
                    <BookAs groups={["digIT", "fikIT"]} />
                    <DigitButton raised submit text="Submit" />
                </DigitLayout.Column>
            )}
        />
    );
};

export default NewReservationFrom;
