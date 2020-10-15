const {
    handleGetReservations,
    handleAddReservation,
    handleCheckValidTime,
} = require("../controllers/reservation.controller");

const getReservationRoutes = router => {
    router.get("/reservation", handleGetReservations);
    router.post("/reservation", handleAddReservation);
    router.post("/reservation/isBookableTime", handleCheckValidTime);
    return router;
};

module.exports = getReservationRoutes;
