import React from "react";
import FullCallendar from "@fullcalendar/react";
import timeGridPlugin from "@fullcalendar/timegrid";

const PhoneCalendar = () => (
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
        height="80%"
        headerToolbar={{
            start: "title",
            center: "",
            end: "today,prev,next",
        }}
        plugins={[timeGridPlugin]}
        initialView="timeGridDay"
        eventOverlap
        events={[
            {
                title: "Styrit Möte",
                start: new Date(),
                end: "2020-08-29T07:00",
                display: "block",
            },
        ]}
    />
);

export default PhoneCalendar;
