import React from "react";
import {
    DigitList,
    DigitDesign,
    DigitText,
    DigitIconButton,
} from "@cthit/react-digit-components";
import MailIcon from "@material-ui/icons/Mail";
import DeleteIcon from "@material-ui/icons/Delete";
import AddIcon from "@material-ui/icons/Add";

const Admin = () => {
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
        </div>
    );
};

export default Admin;
