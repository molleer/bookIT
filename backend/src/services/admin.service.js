const admin_authority_id = process.env.ADMIN_AUTHORITY_ID;
const mock_mode = process.env.MOCK_MODE;

const isAdmin = authorities => {
    if (mock_mode === "true") return true;
    if (admin_authority_id == "") return false;

    for (var i in authorities) {
        if (authorities[i].id === admin_authority_id) return true;
    }

    return false;
};

module.exports = {
    isAdmin,
};
