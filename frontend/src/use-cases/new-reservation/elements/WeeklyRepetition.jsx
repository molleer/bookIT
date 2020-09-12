import React, { useState } from "react";
import {
    useDigitFormField,
    DigitCheckbox,
} from "@cthit/react-digit-components";
import TimePicker from "./TimePicker";

const WeeklyRepetition = () => {
    const wantRepValues = useDigitFormField("wants_repetition");
    const [wantRep, setWantRep] = useState(false);
    return (
        <>
            <DigitCheckbox
                size={{ width: "100%" }}
                {...wantRepValues}
                onChange={e => {
                    setWantRep(e.target.checked);
                    return wantRepValues.onChange(e);
                }}
                label="Jag vill repetera denna bokning veckoligen"
            />
            {wantRep && <TimePicker name="repeat_to" label="Repeteras tills" />}
        </>
    );
};

export default WeeklyRepetition;
