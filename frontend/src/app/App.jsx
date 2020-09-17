import React from "react";
import { Route, Switch } from "react-router-dom";
import Rooms from "../use-cases/rooms";
import Reservations from "../use-cases/reservations";
import Header from "./elements/header";
import NewReservation from "../use-cases/new-reservation";
import Admin from "../use-cases/admin";

function App() {
    return (
        <Header>
            <Switch>
                <Route path={"/reservations/new"} component={NewReservation} />
                <Route path={"/reservations"} component={Reservations} />
                <Route path={"/rooms"} component={Rooms} />
                <Route path={"/admin"} component={Admin} />
            </Switch>
        </Header>
    );
}

export default App;
