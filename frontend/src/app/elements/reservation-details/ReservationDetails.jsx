import React from "react";
import { DigitDisplayData } from "@cthit/react-digit-components";
import { useEffect } from "react";

const ReservationDetails = ({ reservation }) => {
    useEffect(() => {
        console.log(reservation);
    });
    return (
        <DigitDisplayData
            data={reservation}
            keysText={{
                begin_date: "Start datum:",
                end_date: "Slut datum:",
                description: "Beskrivning:",
            }}
            keysOrder={["begin_date", "end_date", "description"]}
        />
    );
};

export default ReservationDetails;
