const {
    handleGetReservations,
    handleAddReservation,
} = require("../controllers/reservation.controller");

const getReservationRoutes = router => {
    router.get("/reservation", handleGetReservations);
    router.post("/reservation", handleAddReservation);
    return router;
};

module.exports = getReservationRoutes;
