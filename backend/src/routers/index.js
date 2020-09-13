const getRoomRoutes = require("./room.router");
const getReservationRoutes = require("./reservation.router");

const initRouters = (app, createRouter) => {
    app.use("/api", getRoomRoutes(createRouter()));
    app.use("/api", getReservationRoutes(createRouter()));
};

module.exports = initRouters;
