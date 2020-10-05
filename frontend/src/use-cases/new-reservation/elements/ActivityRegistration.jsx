import React, { useState } from "react";
import {
    useDigitFormField as formField,
    DigitCheckbox,
    DigitAutocompleteSelectSingle,
    DigitTextField,
    DigitLayout,
} from "@cthit/react-digit-components";

const ActivityRegistration = ({ users }) => {
    const activityValues = formField("isActivity");
    const permitValues = formField("permit");
    const repNameValues = formField("responsible_name");
    const repNumberValues = formField("responsible_number");
    const repEmailValues = formField("responsible_email");
    const repCidValues = formField("responsible_cid");
    const [manuallMode, setManuallMode] = useState(false);

    return (
        <>
            <DigitCheckbox
                {...activityValues}
                label="Jag vill aktivitetsanmäla"
                size={{ width: "100%" }}
            />
            {activityValues.value && (
                <>
                    <DigitCheckbox
                        {...permitValues}
                        label="Serveringstillstånd"
                    />
                    <DigitLayout.Row>
                        <DigitAutocompleteSelectSingle
                            {...repCidValues}
                            disabled={manuallMode}
                            upperLabel="Aktivitetsansvarig"
                            options={
                                users
                                    ? users.map(user => ({
                                          text: user.nick,
                                          value: user.cid,
                                      }))
                                    : []
                            }
                        />
                        <DigitCheckbox
                            onChange={e => setManuallMode(e.target.checked)}
                            label="Skriv in själv"
                        />
                    </DigitLayout.Row>
                    <DigitLayout.Row>
                        <DigitTextField
                            {...repNameValues}
                            disabled={!manuallMode}
                            upperLabel="Namn aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repNumberValues}
                            disabled={!manuallMode}
                            upperLabel="Tel aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repEmailValues}
                            disabled={!manuallMode}
                            upperLabel="Email aktivitetsansvarig"
                        />
                    </DigitLayout.Row>
                </>
            )}
        </>
    );
};

export default ActivityRegistration;
