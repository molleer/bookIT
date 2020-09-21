import React from "react";
import { DigitCRUD } from "@cthit/react-digit-components";
import { useRef } from "react";
import { useCallback } from "react";
import * as _ from "lodash";

const PolicyCRUD = () => {
    const data = useRef([
        {
            id: "1",
            from: new Date().toString(),
            to: new Date().toString(),
            days: "MON,TUE,WEN,THU,FRI",
            start: "17:00",
            end: "23:59",
            who: "ANY",
        },
        {
            id: "1",
            from: new Date().toString(),
            to: new Date().toString(),
            days: "SAT,SUN",
            start: "00:00",
            end: "23:59",
            who: "ANY",
        },
    ]);

    const getData = () => data.current;

    const setData = newData => {
        data.current = newData;
    };

    const readAllRequestPromises = () =>
        new Promise(resolve => {
            resolve({
                data: getData(),
            });
        });

    const readOneRequestPromise = id =>
        new Promise((resolve, reject) => {
            const result = _.find(getData(), {
                id,
            });

            if (result) {
                setTimeout(
                    () =>
                        resolve({
                            data: { ...result },
                        }),
                    10
                );
            } else {
                console.log("Rejecting");
                reject();
            }
        });

    const readAllRequestCallback = useCallback(readAllRequestPromises, [data]);
    const readOneRequestCallback = useCallback(readOneRequestPromise, [data]);
    return (
        <DigitCRUD
            path="/admin"
            readAllRequest={readAllRequestCallback}
            keysOrder={["id", "from", "to", "days", "who"]}
            keysText={{
                id: "Id",
                from: "From",
                to: "To",
                days: "Days",
                who: "Who?",
            }}
            tableProps={{
                titleText: "Lokal policies",
                search: "true",
                startOrderBy: "id",
            }}
            detailsTitle={data => data.id}
            detailsButtonText={"Details"}
            backButtonText={"Tillbaka"}
            idProp="id"
            readOneRequest={readOneRequestCallback}
        />
    );
};

export default PolicyCRUD;
