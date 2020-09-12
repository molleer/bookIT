import React, { useEffect } from "react";
import { useHistory } from "react-router-dom";
import { postRequest } from "../../../api/utils/api";
import { DigitHeaderDrawer, DigitNavLink } from "@cthit/react-digit-components";

const Header = ({ children }) => {
    const history = useHistory();

    useEffect(() => {
        const paramsResponse = new URLSearchParams(window.location.search);
        const code = paramsResponse.get("code");
        if (code) {
            postRequest("/auth/account/callback", { code })
                .then(() => {
                    history.push("/");
                })
                .catch(error => {
                    history.push("/");
                    console.log("Someting went wrong");
                    console.log(error);
                });
        }
    }, [history]);

    return (
        <DigitHeaderDrawer
            title={"BookIT"}
            renderDrawer={() => (
                <>
                    <DigitNavLink
                        link={"/reservations"}
                        text={"Reservations"}
                    />
                    <DigitNavLink link={"/rooms"} text={"Rooms"} />
                </>
            )}
            renderMain={() => children}
        />
    );
};

export default Header;
