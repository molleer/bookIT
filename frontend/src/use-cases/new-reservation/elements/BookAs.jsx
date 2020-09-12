import React from "react";
import { useDigitFormField, DigitSelect } from "@cthit/react-digit-components";
import { arrayOf, string } from "prop-types";

const BookAs = ({ groups }) => {
    const dropDownValues = useDigitFormField("bookAs");
    const getGroups = () => {
        const groupObject = {};
        for (var i = 0; i < groups.length; i++)
            groupObject[groups[i]] = groups[i];
        return groupObject;
    };
    return (
        <DigitSelect
            {...dropDownValues}
            upperLabel="Boka som"
            valueToTextMap={getGroups()}
        />
    );
};

BookAs.propTypes = {
    groups: arrayOf(string),
};

export default BookAs;
