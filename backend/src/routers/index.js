const getRoomRoutes = require("./room.router");
const getReservationRoutes = require("./reservation.router");
const getGammaRouter = require("./gamma.router");

const initRouters = (app, createRouter) => {
    app.use("/api", getRoomRoutes(createRouter()));
    app.use("/api", getReservationRoutes(createRouter()));
    app.use("/api/gamma", getGammaRouter(createRouter()));
};

module.exports = initRouters;
