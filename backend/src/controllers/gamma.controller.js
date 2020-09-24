const { to } = require("../utils");
const { gammaGet } = require("../utils/gamma");

const handleGetMe = async (req, res) => {
    const [, me] = await to(gammaGet("/users/me", req.session.token));
    res.send(me.data);
    res.status(me.status).end();
};

module.exports = {
    handleGetMe,
};
