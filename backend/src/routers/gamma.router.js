const { handleGetMe } = require("../controllers/gamma.controller");

const getGammaRouter = router => {
    router.get("/me", handleGetMe);
    return router;
};

module.exports = getGammaRouter;
