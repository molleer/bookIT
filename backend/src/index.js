const express = require("express");
const { initExpress, initDB, getApp } = require("./utils");
const { getSessionMiddleware } = require("./middlewares/session");
const { getAuthenticationMiddleware } = require("./middlewares/authentication");
const { getRequireBodyOnPost } = require("./middlewares/require-body-on-post");
const initRouters = require("./routers");

initExpress();
initDB();

const app = getApp();
app.use(getSessionMiddleware(app));
app.use(getAuthenticationMiddleware());
app.use(getRequireBodyOnPost());
initRouters(app, () => express.Router());
