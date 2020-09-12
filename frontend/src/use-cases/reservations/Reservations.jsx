import React from "react";
import { DigitButtonGroup } from "@cthit/react-digit-components";
import { Redirect } from "react-router-dom";
import { useState } from "react";
import Calendar from "./views/Calendar";
import PhoneCalendar from "./views/PhoneCaendar";
import { useEffect } from "react";

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
            {window.innerWidth > 600 ? <Calendar /> : <PhoneCalendar />}
        </div>
    );
};

export default Reservations;
