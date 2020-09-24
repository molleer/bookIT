const jwt = require("jsonwebtoken");
const { to } = require("../utils");
const { getGammaUri, postGammaToken } = require("../utils/gamma");

const getAuthenticationMiddleware = () => {
    return async (req, res, next) => {
        //If user signed in, continue...
        if (req.session.cid) {
            console.log("yay signed in: " + req.session.cid);
            next();
        } else {
            //If user is trying to create session
            const { code } = req.body;
            if (
                req.path === "/api/auth/account/callback" &&
                req.method === "POST" &&
                code != null
            ) {
                const [err, response] = await to(postGammaToken(code));
                if (err) {
                    if (err.response && err.response.status === 400) {
                        res.status(400).send(
                            "code either outdated or incorrect"
                        );
                        console.log(err.response);
                    } else {
                        res.status(500).end();
                        console.log(err);
                    }
                } else {
                    const { access_token, expires_in } = response.data;
                    req.session.cookie.maxAge = expires_in;

                    const { user_name, authorities } = jwt.decode(access_token);
                    req.session.cid = user_name;
                    req.session.authorities = authorities;
                    req.session.token = access_token;
                    req.session.save(err => console.log(err));
                    res.status(200).send("session created");
                }
            } else {
                res.status(403).send(getGammaUri());
            }
        }
    };
};

module.exports = {
    getAuthenticationMiddleware,
};
