const uuid = require("uuid/v4");
const yup = require("yup");
const { to, validateSchema } = require("../utils");
const db = require("../db/reservation.db");
const { getOverlappingReservations } = require("../db/reservation.db");

const reservationSchema = yup.object().shape({
    title: yup.string().required(),
    description: yup.string(),
    begin_date: yup.date().required(),
    end_date: yup.date().required(),
    bookAs: yup.string().required(),
    room: yup.string().required(),
});

const createReservation = async (user, body, id = uuid()) => {
    var err = await validateReservation(user, body);

    if (err != null) {
        return [err, null];
    }

    [err] = await to(db.addReservation(id, { ...body }));

    return [err, id];
};

const getReservations = async () => {
    return await to(db.getReservations());
};

const validateTime = async (from, to_date, room_id) => {
    //If the event starts before it stops
    if (new Date(from) >= new Date(to_date))
        return Error("End date must be greater than begin date");

    //Fetches all overlapping
    var [err, rows] = await to(
        getOverlappingReservations(from, to_date, room_id)
    );

    return err || rows.length
        ? new Error("The time selected is overlapping with another reservation")
        : null;
};

const validateReservation = async (user, body) => {
    const schemaErrors = await validateSchema(reservationSchema, body);
    //If body follows validation schema
    if (schemaErrors) return schemaErrors;

    //If the user is a member of the booked group
    if (
        body.bookAs !== "private" &&
        !user.groups.find(group => group.superGroup.name === body.bookAs)
    ) {
        return new Error(`${user.cid} is not a member of '${body.bookAs}'`);
    }

    return validateTime(body.begin_date, body.end_date, body.room);
};

module.exports = {
    createReservation,
    getReservations,
    validateTime,
};
