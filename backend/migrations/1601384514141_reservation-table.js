/* eslint-disable camelcase */

exports.shorthands = undefined;

exports.up = pgm => {
    pgm.createTable("reservation", {
        id: {
            type: "uuid",
            primaryKey: true,
        },
        title: {
            type: "text",
            notNull: true,
        },
        description: {
            type: "text",
        },
        accepted: {
            type: "boolean",
            notNull: true,
            default: false,
        },
        begin_date: {
            type: "timestamp",
            notNull: true,
        },
        end_date: {
            type: "timestamp",
            notNull: true,
        },
        created_at: {
            type: "timestamp",
            notNull: true,
            default: pgm.func("NOW()"),
        },
        updated_at: {
            type: "timestamp",
            notNull: true,
            default: pgm.func("NOW()"),
        },
    });
};

exports.down = pgm => {};
