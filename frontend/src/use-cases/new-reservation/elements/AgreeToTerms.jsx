import React from "react";
import {
    useDigitFormField,
    DigitCheckbox,
} from "@cthit/react-digit-components";

const AgreeToTerms = () => {
    const termsValues = useDigitFormField("agreeToTerms");
    return (
        <DigitCheckbox
            {...termsValues}
            label="Jag har läst igenom och accepterar bokningsvillkoren*"
            size={{ width: "100%", height: "100%" }}
        />
    );
};

export default AgreeToTerms;
