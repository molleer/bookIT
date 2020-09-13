import React from "react";
import NewReservationFrom from "./NewReservation.form";
import { DigitDesign, DigitLayout } from "@cthit/react-digit-components";
import { createReservation } from "../../api/reservations";

const NewReservation = () => {
    const handleSubmit = values => {
        createReservation(values)
            .then(res => console.log("Reservation created"))
            .catch(err => {
                console.log("Failed to create reservation");
                console.log(err);
            });
    };

    return (
        <DigitLayout.Center>
            <DigitDesign.Card>
                <DigitDesign.CardBody>
                    <DigitDesign.CardTitle text="Ny bokning" />
                    <NewReservationFrom onSubmit={handleSubmit} />
                </DigitDesign.CardBody>
            </DigitDesign.Card>
        </DigitLayout.Center>
    );
};

export default NewReservation;
