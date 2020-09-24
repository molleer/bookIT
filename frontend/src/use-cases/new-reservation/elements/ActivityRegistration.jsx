import React, { useState } from "react";
import {
    useDigitFormField as formField,
    DigitCheckbox,
    DigitAutocompleteSelectSingle,
} from "@cthit/react-digit-components";

const ActivityRegistration = ({ users }) => {
    const activityValues = formField("isActivity");
    const permitValues = formField("permit");
    const repNameValues = formField("responsible_name");
    const repNumberValues = formField("responsible_number");
    const repEmailValues = formField("responsible_email");
    const [isActivity, setIsActivity] = useState(false);
    return (
        <>
            <DigitCheckbox
                {...activityValues}
                onChange={e => {
                    setIsActivity(e.target.checked);
                    return activityValues.onChange(e);
                }}
                label="Jag vill aktivitetsanmäla"
                size={{ width: "100%" }}
            />
            {isActivity && (
                <>
                    <DigitAutocompleteSelectSingle
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
                </>
            )}
        </>
    );
};

export default ActivityRegistration;
