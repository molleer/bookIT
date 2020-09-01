import React from "react";
import NewReservationFrom from "./NewReservation.form";

const NewReservation = () => (
    <NewReservationFrom onSubmit={values => console.log(values)} />
);

export default NewReservation;
