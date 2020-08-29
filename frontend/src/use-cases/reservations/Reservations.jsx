import React from "react";
import FullCallendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import { DigitDesign } from "@cthit/react-digit-components";

const Reservations = () => {
    return (
        <div style={{ display: "flex", justifyContent: "center" }}>
            <DigitDesign.Card
                size={{ width: "95%" }}
                style={{ marginTop: "2rem" }}
            >
                <DigitDesign.CardBody>
                    <FullCallendar
                        eventTimeFormat={{
                            hour: "2-digit",
                            minute: "2-digit",
                            hour12: false,
                        }}
                        slotLabelFormat={{
                            hour: "2-digit",
                            minute: "2-digit",
                            hour12: false,
                        }}
                        rerenderDelay={1000}
                        allDaySlot
                        weekNumbers
                        editable
                        headerToolbar={{
                            start: "title",
                            center: "",
                            end: "today,prev,next",
                        }}
                        plugins={[dayGridPlugin, timeGridPlugin]}
                        initialView="timeGridWeek"
                        eventOverlap
                        events={[
                            {
                                title: "Styrit Möte",
                                start: "2020-08-29T06:00",
                                end: "2020-08-29T07:00",
                                display: "block",
                            },
                            {
                                title: "Styrit Möte",
                                start: "2020-08-29T12:00",
                                end: "2020-08-29T13:00",
                                display: "block",
                            },
                            {
                                title: "Styrit Möte",
                                start: "2020-08-29T12:30",
                                end: "2020-08-29T13:30",
                                display: "block",
                            },
                        ]}
                    />
                </DigitDesign.CardBody>
            </DigitDesign.Card>
        </div>
    );
};

export default Reservations;
