import React, { useState, useEffect } from "react";
import UserContext from "./User.context";
import { getRequest } from "../../../api/utils/api";

const UserProvider = ({ children }) => {
    const [me, setMe] = useState(null);
    useEffect(() => {
        getRequest("/gamma/me").then(res => {
            setMe(res.data);
        });
    }, []);
    return <UserContext.Provider value={me}>{children}</UserContext.Provider>;
};

export default UserProvider;
