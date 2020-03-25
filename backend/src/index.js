const { initExpress, initDB, getApp } = require("./utils");
const { getSessionMiddleware } = require("./middlewares/session");
const { getAuthenticationMiddleware } = require("./middlewares/authentication");

initExpress();
initDB();

const app = getApp();
app.use(getSessionMiddleware(app));
app.use(getAuthenticationMiddleware());

require("./controllers/room.controller");
