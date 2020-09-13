const getRoomRoutes = require("./room.router");

const initRouters = (app, createRouter) => {
    app.use("/api", getRoomRoutes(createRouter()));
};

module.exports = initRouters;
