import React, { useEffect } from "react";
import { DigitHeader, DigitButton } from "@cthit/react-digit-components";
import { Route, Switch, useHistory } from "react-router-dom";
import Rooms from "../use-cases/rooms";
import { postRequest } from "../api/utils/api";

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
      renderMain={() => (
        <Switch>
          <Route path={"/rooms"} component={Rooms} />
          <DigitButton onClick={() => history.push("/rooms")} text={"hej"} />
        </Switch>
      )}
    />
  );
}

export default App;
