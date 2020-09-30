const uuid = require("uuid/v4");
const yup = require("yup");
const { to, validateSchema } = require("../utils");
const db = require("../db/reservation.db");
const { gammaGet } = require("../utils/gamma");

const reservationSchema = yup.object().shape({
    title: yup.string().required(),
    description: yup.string(),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
    bookAs: yup.string().required(),
});

const createReservation = async (token, body) => {
    const id = uuid();

    const [, me] = await to(gammaGet("/users/me", token));
    var err = await validBooking(me.data, body);

    if (err != null) {
        return [err, null];
    }

    [err] = await to(db.addReservation(id, { ...body }));

    return [err, id];
};

const getReservations = async () => {
    return await to(db.getReservations());
};

const validBooking = async (user, body) => {
    const schemaErrors = await validateSchema(reservationSchema, body);
    if (schemaErrors) return schemaErrors;
    if (body.bookAs === "private") return null;

    const group = user.groups.find(
        group => group.superGroup.name === body.bookAs
    );
    return group
        ? null
        : new Error(`${user.cid} is not a member of '${body.bookAs}'`);
};

module.exports = {
    createReservation,
    getReservations,
};
