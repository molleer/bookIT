import React from "react";
import FullCallendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";

const Calendar = ({ events }) => {
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
            headerToolbar={{
                start: "title",
                center: "",
                end: "today,prev,next",
            }}
            plugins={[dayGridPlugin, timeGridPlugin]}
            initialView="timeGridWeek"
            eventOverlap
            events={events}
        />
    );
};

export default Calendar;
