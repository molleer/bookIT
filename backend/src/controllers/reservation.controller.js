const {
    createReservation,
    getReservations,
} = require("../services/reservation.service");

const handleAddReservation = async (req, res) => {
    const [err, id] = await createReservation(req.session.token, req.body);

    if (err) {
        res.sendStatus(500);
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

module.exports = {
    handleGetReservations,
    handleAddReservation,
};
