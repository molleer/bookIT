import React, { useEffect } from "react";
import { DigitHeader, DigitNavLink } from "@cthit/react-digit-components";
import { Route, Switch, useHistory } from "react-router-dom";
import { postRequest } from "../api/utils/api";
import Rooms from "../use-cases/rooms";
import Reservations from "../use-cases/reservations";

function App() {
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
    }, [window.location.search]);

    return (
        <DigitHeader
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
            renderMain={() => (
                <Switch>
                    <Route path={"/reservations"} component={Reservations} />
                    <Route path={"/rooms"} component={Rooms} />
                </Switch>
            )}
        />
    );
}

export default App;
