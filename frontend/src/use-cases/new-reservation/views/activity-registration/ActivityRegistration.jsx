import React, { useState, useEffect } from "react";
import {
    useDigitFormField as formField,
    DigitCheckbox,
    DigitAutocompleteSelectSingle,
    DigitTextField,
    DigitLayout,
} from "@cthit/react-digit-components";
import { getRequest } from "../../../../api/utils/api";

const set = value => ({ target: { value } });

const ActivityRegistration = ({ users, defaultUser }) => {
    const activityValues = formField("isActivity");
    const permitValues = formField("permit");
    const repNameValues = formField("responsible_name");
    const repNumberValues = formField("responsible_number");
    const repEmailValues = formField("responsible_email");
    const [repCid, setRepCid] = useState(defaultUser);
    const [manuallMode, setManuallMode] = useState(false);

    useEffect(() => {
        if (!repCid) return;
        getRequest(`/gamma/users/${repCid}`)
            .then(res => {
                const user = res.data;
                repNameValues.onChange(
                    set(`${user.firstName} '${user.nick}' ${user.lastName}`)
                );
                repNumberValues.onChange(set(user.phone ?? ""));
                repEmailValues.onChange(
                    set(user.email ?? user.cid + "@student.chalmers.se")
                );
                if (!user.phone) setManuallMode(true);

                console.log(user);
            })
            .catch(err => {
                console.log("Unable to fetch user " + repCid);
                console.log(err);
            });
    }, [repCid]);

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
                            value={repCid}
                            disabled={manuallMode}
                            upperLabel="Aktivitetsansvarig"
                            options={
                                users
                                    ? users.map(user => ({
                                          text: user.nick,
                                          value: user.id,
                                      }))
                                    : []
                            }
                            onChange={e => setRepCid(e.target.value)}
                        />
                        <DigitCheckbox
                            vlaue={manuallMode}
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
