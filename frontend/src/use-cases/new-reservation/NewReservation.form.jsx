import React, { useCallback } from "react";
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
    DigitCheckbox,
    DigitText,
    //DigitRadioButtonGroup,
} from "@cthit/react-digit-components";
import * as yup from "yup";
import PropTypes from "prop-types";
import { useState } from "react";
import { Link } from "react-router-dom";

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

const ActivityRegistration = () => {
    const activityValues = useDigitFormField("isActivity");
    const permitValues = useDigitFormField("permit");
    const repNameValues = useDigitFormField("responsible_name");
    const repNumberValues = useDigitFormField("responsible_number");
    const repEmailValues = useDigitFormField("responsible_email");
    const [isActivity, setIsActivity] = useState(false);
    return (
        <>
            <DigitCheckbox
                {...activityValues}
                onChange={e => {
                    setIsActivity(e.target.checked);
                    return activityValues.onChange(e);
                }}
                label="Jag vill aktivitetsanmäla"
                size={{ width: "100%" }}
            />
            {isActivity && (
                <>
                    <DigitCheckbox
                        {...permitValues}
                        label="Serveringstillstånd"
                    />
                    <DigitLayout.Row>
                        <DigitTextField
                            {...repNameValues}
                            upperLabel="Namn aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repNumberValues}
                            upperLabel="Tel aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repEmailValues}
                            upperLabel="Email aktivitetsansvarig"
                        />
                    </DigitLayout.Row>
                </>
            )}
        </>
    );
};

const AgreeToTerm = () => {
    const termsValues = useDigitFormField("agreeToTerms");
    return (
        <DigitCheckbox
            {...termsValues}
            label="Jag har läst igenom och accepterar bokningsvillkoren*"
            size={{ width: "100%" }}
        />
    );
};

const whenTrue = {
    is: true,
    then: yup.string().required(),
    otherwise: yup.string(),
};

const validationSchema = yup.object().shape({
    title: yup.string().required(),
    phone: yup.string().required(),
    //room: yup.string().required(),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
    bookAs: yup.string().required(),
    isActivity: yup.bool().required(),
    permit: yup.bool(),
    responsible_name: yup.string().when("isActivity", whenTrue),
    responsible_number: yup.string().when("isActivity", whenTrue),
    responsible_email: yup.string().when("isActivity", whenTrue),
    agreeToTerms: yup.mixed().oneOf([true]),
    /*is_activity: yup.bool(),
    activity_contact_number: yup.lazy(({ is_activity }) =>
        is_activity ? yup.string() : yup.string().required()
    ),*/
});

const NewReservationFrom = ({ onSubmit }) => {
    return (
        <DigitForm
            initialValues={{
                title: "Event",
                phone: "123",
                //room: "hubben",
                begin_date: new Date(),
                end_date: new Date(),
                description: "Hi there",
                bookAs: "digIT",
                isActivity: false,
                permit: false,
                responsible_name: "",
                responsible_number: "",
                responsible_email: "",
                agreeToTerms: false,
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
                    <ActivityRegistration />
                    <AgreeToTerm />
                    <a href="https://prit.chalmers.it/Bokningsvillkor.pdf">
                        <DigitText.Subtitle text="*bokningsvillkoren" />
                    </a>
                    <DigitButton raised submit text="Submit" />
                </DigitLayout.Column>
            )}
        />
    );
};

export default NewReservationFrom;
