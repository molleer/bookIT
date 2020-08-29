import React from "react";
import { Route, Switch } from "react-router-dom";
import Rooms from "../use-cases/rooms";
import Reservations from "../use-cases/reservations";
import Header from "./elements/header";

function App() {
    return (
        <Header>
            <Switch>
                <Route path={"/reservations"} component={Reservations} />
                <Route path={"/rooms"} component={Rooms} />
            </Switch>
        </Header>
    );
}

export default App;
