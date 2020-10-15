import React, { useContext, useState, useEffect } from "react";
import {
    DigitForm,
    DigitLayout,
    DigitButton,
    DigitText,
    useDigitToast,
    useDigitFormField,
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
import { getRequest, postRequest } from "../../api/utils/api";
import { getRooms } from "../../api/rooms/get.rooms";
import * as moment from "moment";
import ActivityRegistration from "./views/activity-registration";
import CheckCircleIcon from "@material-ui/icons/CheckCircle";
import CancelIcon from "@material-ui/icons/Cancel";

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

const default_begin_date = new Date();
const default_end_date = moment(new Date())
    .add(1, "h")
    .toDate();

const initialValues = {
    title: "Event",
    phone: "123",
    room: "",
    begin_date: default_begin_date,
    end_date: default_end_date,
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
    const [beginDate, setBeginDate] = useState(default_begin_date);
    const [endDate, setEndDate] = useState(default_end_date);
    const [room, setRoom] = useState(null);
    const [validTime, setValidTime] = useState(false);

    useEffect(() => {
        if (!room) return;
        if (endDate <= beginDate) return setValidTime(false);

        postRequest("/reservation/isBookableTime", {
            begin_date: beginDate,
            end_date: endDate,
            room: room,
        })
            .then(res => setValidTime(res.data))
            .catch(err => {
                console.log(err);
                setValidTime(false);
            });
    }, [endDate, beginDate, room]);

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
                    <Rooms
                        rooms={rooms}
                        onChange={e => setRoom(e.target.value)}
                    />
                    <DigitLayout.Row>
                        <TimePicker
                            name="begin_date"
                            label="Startdatum"
                            onChange={e => setBeginDate(e.target.value)}
                        />
                        <TimePicker
                            name="end_date"
                            label="Slutdatum"
                            onChange={e => setEndDate(e.target.value)}
                        />
                        {!room ? null : validTime ? (
                            <CheckCircleIcon style={{ color: "green" }} />
                        ) : (
                            <CancelIcon style={{ color: "red" }} />
                        )}
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
