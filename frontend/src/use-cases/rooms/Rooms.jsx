import React, { useEffect, useState } from "react";
import { getRoom, getRooms } from "../../api/rooms/get.rooms";
import { DigitCRUD, DigitTextField } from "@cthit/react-digit-components";
import { updateRoom } from "../../api/rooms/put.rooms";
import * as yup from "yup";
import { createRoom } from "../../api/rooms/post.rooms";

const Rooms = () => {
    const [, setRooms] = useState(null);

    useEffect(() => {
        getRooms().then(response => setRooms(response.data));
    }, []);

    return (
        <DigitCRUD
            name={"rooms"}
            path={"/rooms"}
            readAllRequest={getRooms}
            readOneRequest={getRoom}
            updateRequest={updateRoom}
            createRequest={createRoom}
            keysText={{
                name: "Name",
            }}
            keysOrder={["name"]}
            idProp={"id"}
            formInitialValues={{
                name: "",
            }}
            formComponentData={{
                name: {
                    component: DigitTextField,
                    componentProps: {},
                },
            }}
            formValidationSchema={yup.object().shape({
                name: yup.string(),
            })}
            useKeyTextsInUpperLabel
            tableProps={{
                titleText: "Rooms",
            }}
        />
    );
};

export default Rooms;
