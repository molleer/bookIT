DROP SCHEMA public CASCADE;

CREATE SCHEMA public;

CREATE TABLE room (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE reservation (
    id UUID PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    accepted BOOLEAN NOT NULL DEFAULT FALSE,
    begin_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE reserved_room (
    reservation_id UUID REFERENCES reservation(id) ON DELETE CASCADE,
    room_id UUID REFERENCES room(id) ON DELETE CASCADE,
    PRIMARY KEY (reservation_id, room_id)
);

CREATE VIEW upcoming_reservations AS (
    SELECT * FROM reservation
    WHERE NOW() < end_date
);

CREATE VIEW past_reservations AS (
    SELECT * FROM reservation
    WHERE NOW() > end_date
);

CREATE VIEW unaccepted_reservations AS (
    SELECT * FROM reservation
    WHERE accepted = FALSE
);

CREATE VIEW accepted_reservations AS (
    SELECT * FROM reservation
    WHERE accepted = TRUE
);
