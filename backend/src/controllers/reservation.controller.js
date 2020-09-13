const uuid = require("uuid/v4");
const yup = require("yup");
const { to, validateSchema } = require("../utils");
const { addReservation, getReservations } = require("../db/reservation.db");

const reservationSchema = yup.object().shape({
    title: yup.string().required(),
    description: yup.string().required(),
    begin_date: yup.string().required(),
    end_date: yup.string().required(),
});

const handleAddReservation = async (req, res) => {
    const id = uuid();

    const schemaErrors = await validateSchema(reservationSchema, req.body);

    if (schemaErrors != null) {
        res.status(422).send(schemaErrors);
        return;
    }

    const [err] = await to(addReservation(id, { ...req.body }));

    if (err) {
        res.sendStatus(500);
    } else {
        res.status(201).send({ id });
    }
};

const handleGetReservations = async (req, res) => {
    const [err, reservations] = await to(getReservations());

    if (err) {
        res.sendStatus(500);
        console.log(err);
    } else {
        res.status(200).send(reservations);
    }
};

module.exports = {
    handleGetReservations,
    handleAddReservation,
};
