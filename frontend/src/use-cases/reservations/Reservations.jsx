import React, { useEffect } from "react";
import {
    DigitButtonGroup,
    useDigitCustomDialog,
} from "@cthit/react-digit-components";
import { Redirect } from "react-router-dom";
import { useState } from "react";
import Calendar from "./views/Calendar";
import PhoneCalendar from "./views/PhoneCaendar";
import { getReservations } from "../../api/reservations";
import ReservationDetails from "./elements/ReservationDetails";

const parseReservations = reservations =>
    reservations.map(e => ({
        ...e,
        start: e.begin_date,
        end: e.end_date,
        display: "block",
    }));

const Reservations = () => {
    const [redirect, setRedirect] = useState(null);
    const [reservations, setReservations] = useState([]);
    const [openDetails] = useDigitCustomDialog();

    useEffect(() => {
        getReservations()
            .then(res => setReservations(parseReservations(res.data)))
            .catch(err => {
                console.log("Unable to fetch reservations");
                console.log(err);
            });
    }, []);

    return (
        <div
            style={{
                display: "flex",
                justifyContent: "center",
                flexDirection: "column",
                width: "95%",
            }}
        >
            {redirect && <Redirect to={redirect} />}
            <DigitButtonGroup
                primary
                outlined
                buttons={[
                    {
                        text: "Skapa bokning",
                        onClick: () => setRedirect("/reservations/new"),
                    },
                    {
                        text: "Dina bokningar",
                    },
                ]}
            />
            {window.innerWidth > 600 ? (
                <Calendar
                    events={reservations}
                    eventClick={e => {
                        openDetails({
                            renderMain: () => (
                                <ReservationDetails
                                    reservation={e.event.extendedProps}
                                />
                            ),
                            title: e.event.title,
                        });
                    }}
                />
            ) : (
                <PhoneCalendar events={reservations} />
            )}
        </div>
    );
};

export default Reservations;
