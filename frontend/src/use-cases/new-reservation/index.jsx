import React from "react";
import NewReservationFrom from "./NewReservation.form";
import {
    DigitDesign,
    DigitLayout,
    DigitText,
} from "@cthit/react-digit-components";

const NewReservation = () => (
    <DigitLayout.Center>
        <DigitDesign.Card>
            <DigitDesign.CardBody>
                <DigitDesign.CardTitle text="Ny bokning" />
                <NewReservationFrom onSubmit={values => console.log(values)} />
            </DigitDesign.CardBody>
        </DigitDesign.Card>
    </DigitLayout.Center>
);

export default NewReservation;
