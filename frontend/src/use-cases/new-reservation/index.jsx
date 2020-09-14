import React, { useState } from "react";
import NewReservationFrom from "./NewReservation.form";
import {
    DigitDesign,
    DigitLayout,
    useDigitToast,
} from "@cthit/react-digit-components";
import { createReservation } from "../../api/reservations";
import { Redirect } from "react-router-dom";

const NewReservation = () => {
    const [openToast] = useDigitToast({
        duration: 3000,
        actionText: "Ok",
        actionHandler: () => {},
    });

    const [redirect, setRedirect] = useState(null);

    const handleSubmit = values => {
        createReservation(values)
            .then(res => {
                openToast({
                    text: "Bokning skapats",
                });
                setRedirect("/");
            })
            .catch(err => {
                openToast({
                    text: "Error: Bokning misslyckades",
                });
                console.log(err);
            });
    };

    return (
        <DigitLayout.Center>
            <DigitDesign.Card>
                <DigitDesign.CardBody>
                    {redirect && <Redirect to={redirect} />}
                    <DigitDesign.CardTitle text="Ny bokning" />
                    <NewReservationFrom onSubmit={handleSubmit} />
                </DigitDesign.CardBody>
            </DigitDesign.Card>
        </DigitLayout.Center>
    );
};

export default NewReservation;
