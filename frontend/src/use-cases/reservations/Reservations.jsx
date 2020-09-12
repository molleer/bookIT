import React from "react";
import { DigitButtonGroup } from "@cthit/react-digit-components";
import { Redirect } from "react-router-dom";
import { useState } from "react";
import Calendar from "./views/Calendar";
import PhoneCalendar from "./views/PhoneCaendar";
const events = [
    {
        title: "Styrit Möte",
        start: "2020-08-29T06:00",
        end: "2020-08-29T07:00",
        display: "block",
    },
    {
        title: "Styrit Möte",
        start: "2020-08-29T12:00",
        end: "2020-08-29T13:00",
        display: "block",
    },
    {
        title: "Styrit Möte",
        start: "2020-08-29T12:30",
        end: "2020-08-29T13:30",
        display: "block",
    },
];

const Reservations = () => {
    const [redirect, setRedirect] = useState(null);
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
                <Calendar events={events} />
            ) : (
                <PhoneCalendar events={events} />
            )}
        </div>
    );
};

export default Reservations;
