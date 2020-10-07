import React, { useEffect, useState } from "react";
import {
    DigitList,
    DigitDesign,
    DigitIconButton,
    DigitTable,
    useDigitCustomDialog,
} from "@cthit/react-digit-components";
import MailIcon from "@material-ui/icons/Mail";
import DeleteIcon from "@material-ui/icons/Delete";
import AddIcon from "@material-ui/icons/Add";
import { getReservations } from "../../api/reservations";
//import PolicyCRUD from "./views/PolicyCRUD";
import { formatDate } from "../../app/utils";
import { useHistory } from "react-router-dom";
import ReservationDetails from "../../app/elements/reservation-details";
import { ButtonRight, Wrapper } from "./Admin.style";

const Admin = () => {
    const [reservations, setReservations] = useState([]);
    const history = useHistory();
    const [openDetails] = useDigitCustomDialog();

    const formatData = data => {
        for (var i in data) {
            data[i].begin_date = formatDate(data[i].begin_date);
            data[i].end_date = formatDate(data[i].end_date);
            data[i].__link = "/admin/reservation/" + data[i].id;
        }

        return data;
    };

    useEffect(() => {
        getReservations()
            .then(res => setReservations(formatData(res.data)))
            .catch(err => {
                console.log("Unable to fetch reservations");
                console.log(err);
            });
    }, []);

    useEffect(() => {
        if (history.location.pathname.includes("/admin/reservation/")) {
            const id = history.location.pathname.substr(
                "/admin/reservation/".length
            );

            const reservation = reservations.find(res => res.id == id);
            if (!reservation) return;
            openDetails({
                renderMain: () => (
                    <ReservationDetails reservation={reservation} />
                ),
                title: reservation.title,
            });
        }
    }, [history.location]);

    return (
        <Wrapper>
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
                <ButtonRight>
                    <DigitIconButton icon={AddIcon} primary />
                </ButtonRight>
            </DigitDesign.Card>
            <DigitTable
                titleText="Bokningar"
                idProp="id"
                startOrderBy="begin_date"
                columnsOrder={["title", "begin_date", "end_date", "age"]}
                headerTexts={{
                    title: "Titel",
                    begin_date: "Startar",
                    end_date: "Slutar",
                    __link: "Detaljer",
                }}
                data={reservations}
            />
            {/**<PolicyCRUD /> */}
        </Wrapper>
    );
};

export default Admin;
