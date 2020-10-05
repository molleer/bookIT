const { to } = require("../utils");
const { gammaGet } = require("../utils/gamma");

const handleGetMe = async (req, res) => {
    const [, me] = await to(gammaGet("/users/me", req.session.token));
    res.send(me.data);
    res.status(me.status).end();
    if (me.status == 200) console.log("Success");
};

const handleGetUsers = async (req, res) => {
    const [, users] = await to(gammaGet("/users/minified", req.session.token));
    res.send(users.data);
    res.status(users.status).end();
};

const handleGetUser = async (req, res) => {
    const [, user] = await to(
        gammaGet("/users/" + req.params.cid, req.session.token)
    );
    res.send(user.data);
    res.status(user.status).end();
};

module.exports = {
    handleGetMe,
    handleGetUsers,
    handleGetUser,
};
