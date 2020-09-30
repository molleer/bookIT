const uuid = require("uuid/v4");
const yup = require("yup");
const { to, validateSchema } = require("../utils");
const db = require("../db/reservation.db");

const reservationSchema = yup.object().shape({
    title: yup.string().required(),
    description: yup.string().required(),
    begin_date: yup.string().required(),
    end_date: yup.string().required(),
});

const createReservation = async body => {
    const id = uuid();

    const schemaErrors = await validateSchema(reservationSchema, body);

    if (schemaErrors != null) {
        return [schemaErrors, null];
    }

    const [err] = await to(db.addReservation(id, { ...body }));

    return [err, id];
};

const getReservations = async () => {
    return await to(db.getReservations());
};

module.exports = {
    createReservation,
    getReservations,
};
