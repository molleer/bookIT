import React, { useEffect } from "react";
import {
    DigitButtonGroup,
    useDigitCustomDialog,
} from "@cthit/react-digit-components";
import { Redirect } from "react-router-dom";
import { useState } from "react";
import Calendar from "./views/Calendar";
import { getReservations } from "../../api/reservations";
import ReservationDetails from "../../app/elements/reservation-details";
import { Wrapper } from "./Reservations.style";

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
        <Wrapper>
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
        </Wrapper>
    );
};

export default Reservations;
