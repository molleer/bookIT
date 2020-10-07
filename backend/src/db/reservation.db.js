const { query } = require("../utils");

const getReservations = () =>
    query(
        "SELECT * FROM reservation ORDER BY begin_date",
        null,
        results => results.rows
    );

const getReservation = id =>
    query("SELECT * FROM reservation WHERE id = $1", [id], results =>
        results.rowCount > 0 ? results.rows[0] : null
    );

const addReservation = (id, data) =>
    query(
        "INSERT INTO reservation (id, title, description, begin_date, end_date, room) VALUES ($1, $2, $3, $4, $5, $6)",
        [
            id,
            data.title,
            data.description,
            data.begin_date,
            data.end_date,
            data.room,
        ],
        results => results.rowCount
    );

const editReservation = (id, data) =>
    query(
        "UPDATE reservation SET title = $2, description = $3, begin_date = $4, end_date = $5, updated_at = NOW() WHERE id = $1",
        [data.id, data.title, data.description, data.begin_date, data.end_date],
        results => results.rowCount
    );

const deleteReservation = id =>
    query(
        "DELETE FROM reservation WHERE id = $1",
        [id],
        results => results.rowCount
    );

const overlap = (b, e) =>
    `(($1 < ${b} AND ${b} < $2) OR ($1 < ${e} AND ${e} < $2) OR (${b} <= $1 AND $2 <= ${e}))`;

const getOverlappingReservations = (from, to, room_id) =>
    query(
        "SELECT * FROM reservation WHERE room=$3 AND " +
            overlap("begin_date", "end_date"),
        [from, to, room_id],
        results => results.rows
    );

module.exports = {
    getReservations,
    getReservation,
    addReservation,
    editReservation,
    deleteReservation,
    getOverlappingReservations,
};
