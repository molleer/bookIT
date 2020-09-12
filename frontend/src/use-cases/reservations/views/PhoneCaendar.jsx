import React from "react";
import FullCallendar from "@fullcalendar/react";
import timeGridPlugin from "@fullcalendar/timegrid";

const PhoneCalendar = ({ events }) => {
    return (
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
            events={events}
        />
    );
};

export default PhoneCalendar;
