import React, { useContext } from "react";
import {
    DigitForm,
    DigitLayout,
    DigitButton,
    DigitText,
    //DigitRadioButtonGroup,
} from "@cthit/react-digit-components";
import * as yup from "yup";
import {
    Title,
    PhoneNumber,
    TimePicker,
    Description,
    BookAs,
    ActivityRegistration,
    AgreeToTerms,
    WeeklyRepetition,
} from "./elements";
import UserContext from "../../app/contexts/user";

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
    wants_repetition: yup.bool(),
    repeat_to: yup.date(),
    /*is_activity: yup.bool(),
    activity_contact_number: yup.lazy(({ is_activity }) =>
        is_activity ? yup.string() : yup.string().required()
    ),*/
});

const initialValues = {
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
    wants_repetition: false,
    repeat_to: new Date(),
    /*is_activity: false,
    activity_contact_number: "",*/
};

const NewReservationFrom = ({ onSubmit }) => {
    const me = useContext(UserContext);
    return (
        <DigitForm
            initialValues={initialValues}
            validationSchema={validationSchema}
            onSubmit={values => {
                validationSchema
                    .validate(values)
                    .then(() => onSubmit(values))
                    .catch(err => console.log(err));
            }}
            render={() => (
                <DigitLayout.Column>
                    <DigitText.Text text={`Bokare: ${me ? me.cid : ""}`} />
                    <Title />
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
                    <BookAs
                        groups={
                            me
                                ? me.groups.map(group => group.superGroup.name)
                                : []
                        }
                    />
                    <ActivityRegistration />
                    <AgreeToTerms />
                    <WeeklyRepetition />
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
