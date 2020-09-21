import React, { useEffect, useState } from "react";
import {
    DigitList,
    DigitDesign,
    DigitIconButton,
    DigitTable,
} from "@cthit/react-digit-components";
import MailIcon from "@material-ui/icons/Mail";
import DeleteIcon from "@material-ui/icons/Delete";
import AddIcon from "@material-ui/icons/Add";
import { getReservations } from "../../api/reservations";
import PolicyCRUD from "./views/PolicyCRUD";

const Admin = () => {
    const [reservations, setReservations] = useState([]);

    useEffect(() => {
        getReservations()
            .then(res => setReservations(res.data))
            .catch(err => {
                console.log("Unable to fetch reservations");
                console.log(err);
            });
    }, []);
    return (
        <div>
            <DigitDesign.Card>
                <DigitDesign.CardBody>
                    <DigitList
                        title="Notifikation vid aktivitetsanälan"
                        items={[
                            {
                                text: "vo@chalmers.it",
                                icon: MailIcon,
                                actionIcon: DeleteIcon,
                            },
                            {
                                text: "ordf.prit@chalmers.it",
                                icon: MailIcon,
                                actionIcon: DeleteIcon,
                            },
                        ]}
                    />
                </DigitDesign.CardBody>
                <DigitDesign.CardButtons style={{ "justify-content": "right" }}>
                    <DigitIconButton icon={AddIcon} primary />
                </DigitDesign.CardButtons>
            </DigitDesign.Card>
            <DigitTable
                titleText="Bokningar"
                idProp="id"
                startOrderBy="begin_date"
                columnsOrder={["id", "begin_date", "end_date", "age"]}
                headerTexts={{
                    id: "Id",
                    begin_date: "Startar",
                    end_date: "Slutar",
                }}
                data={reservations}
            />
            <PolicyCRUD />
        </div>
    );
};

export default Admin;
