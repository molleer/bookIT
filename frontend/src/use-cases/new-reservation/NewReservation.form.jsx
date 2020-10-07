import React, { useContext, useState, useEffect } from "react";
import {
    DigitForm,
    DigitLayout,
    DigitButton,
    DigitText,
    useDigitToast,
    //DigitRadioButtonGroup,
} from "@cthit/react-digit-components";
import * as yup from "yup";
import {
    Title,
    TimePicker,
    Description,
    BookAs,
    AgreeToTerms,
    WeeklyRepetition,
    Rooms,
} from "./elements";
import UserContext from "../../app/contexts/user";
import { getRequest } from "../../api/utils/api";
import { getRooms } from "../../api/rooms/get.rooms";
import * as moment from "moment";
import ActivityRegistration from "./views/activity-registration";

const whenTrue = {
    is: true,
    then: yup.string().required(),
    otherwise: yup.string(),
};

const validationSchema = yup.object().shape({
    title: yup.string().required(),
    phone: yup.string().required(),
    room: yup.string().notOneOf([""], "Du måste välja vilket rum du vill boka"),
    description: yup.string(),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
    bookAs: yup.string().notOneOf([""], "Du måste välja en grupp att boka som"),
    isActivity: yup.bool().required(),
    permit: yup.bool(),
    responsible_name: yup.string().when("isActivity", whenTrue),
    responsible_number: yup.string().when("isActivity", whenTrue),
    responsible_email: yup.string().when("isActivity", whenTrue),
    agreeToTerms: yup
        .mixed()
        .oneOf([true], "Du måste godkänna bokningsvillkoren"),
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
    room: "",
    begin_date: new Date(),
    end_date: moment(new Date())
        .add(1, "h")
        .toDate(),
    description: "Hi there",
    bookAs: "",
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
    const [openToast] = useDigitToast({
        duration: 3000,
        actionText: "Ok",
        actionHandler: () => {},
    });
    const me = useContext(UserContext);
    const [users, setUsers] = useState([]);
    const [rooms, setRooms] = useState([]);

    useEffect(() => {
        getRequest("/gamma/users")
            .then(res => setUsers(res.data))
            .catch(err => console.log("Unable to get users"));
    }, []);

    useEffect(() => {
        getRooms()
            .then(res => setRooms(res.data))
            .catch(err => {
                console.log("Failed to fetch rooms");
                console.log(err);
            });
    }, []);

    return (
        <DigitForm
            initialValues={initialValues}
            validationSchema={validationSchema}
            onSubmit={values => {
                validationSchema
                    .validate(values)
                    .then(() => onSubmit(values))
                    .catch(err =>
                        openToast({
                            text: err.message,
                        })
                    );
            }}
            render={() => (
                <DigitLayout.Column>
                    <DigitText.Text text={`Bokare: ${me ? me.cid : ""}`} />
                    <Title />
                    <Rooms rooms={rooms} />
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
                    <ActivityRegistration users={users} />
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
