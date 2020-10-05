const {
    handleGetMe,
    handleGetUsers,
    handleGetUser,
} = require("../controllers/gamma.controller");

const getGammaRouter = router => {
    router.get("/me", handleGetMe);
    router.get("/users", handleGetUsers);
    router.get("/users/:cid", handleGetUser);
    return router;
};

module.exports = getGammaRouter;
