const {
    createReservation,
    getReservations,
    validateTime,
} = require("../services/reservation.service");
const { to } = require("../utils");
const { getMe } = require("../utils/gamma");

const handleAddReservation = async (req, res) => {
    const [, me] = await to(getMe(req.session.token));
    const [err, id] = await createReservation(me.data, req.body);

    if (err) {
        res.status(400).send(err.message);
    } else {
        res.status(201).send({ id });
    }
};

const handleGetReservations = async (req, res) => {
    const [err, reservations] = await getReservations();

    if (err) {
        res.sendStatus(500);
        console.log(err);
    } else {
        res.status(200).send(reservations);
    }
};

const handleCheckValidTime = async (req, res) => {
    const err = await validateTime(
        req.body.begin_date,
        req.body.end_date,
        req.body.room
    );

    res.status(200).send(err === null);
};

module.exports = {
    handleGetReservations,
    handleAddReservation,
    handleCheckValidTime,
};
