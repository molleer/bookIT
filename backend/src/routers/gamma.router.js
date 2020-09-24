const {
    handleGetMe,
    handleGetUsers,
} = require("../controllers/gamma.controller");

const getGammaRouter = router => {
    router.get("/me", handleGetMe);
    router.get("/users", handleGetUsers);
    return router;
};

module.exports = getGammaRouter;
