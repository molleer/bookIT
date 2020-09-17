import React from "react";
import FullCallendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import PropTypes from "prop-types";

const Calendar = ({ events, eventClick }) => {
    events = events ?? [];
    eventClick = eventClick ?? (() => {});
    return (
        <FullCallendar
            eventClick={eventClick}
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

Calendar.propTypes = {
    events: PropTypes.arrayOf(
        PropTypes.shape({
            title: PropTypes.string.isRequired,
            start: PropTypes.string.isRequired,
            end: PropTypes.string.isRequired,
        })
    ),
    eventClick: PropTypes.func,
};

export default Calendar;
