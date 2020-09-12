import React, { useState } from "react";
import {
    useDigitFormField as formField,
    DigitCheckbox,
    DigitTextField,
    DigitLayout,
} from "@cthit/react-digit-components";

const ActivityRegistration = () => {
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
                    <DigitCheckbox
                        {...permitValues}
                        label="Serveringstillstånd"
                    />
                    <DigitLayout.Row>
                        <DigitTextField
                            {...repNameValues}
                            upperLabel="Namn aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repNumberValues}
                            upperLabel="Tel aktivitetsansvarig"
                        />
                        <DigitTextField
                            {...repEmailValues}
                            upperLabel="Email aktivitetsansvarig"
                        />
                    </DigitLayout.Row>
                </>
            )}
        </>
    );
};

export default ActivityRegistration;
