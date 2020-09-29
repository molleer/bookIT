/* eslint-disable camelcase */

exports.shorthands = undefined;

exports.up = pgm => {
    pgm.createTable("room", {
        id: {
            type: "uuid",
            primaryKey: true,
        },
        name: {
            type: "text",
            notNull: true,
        },
    });
};

exports.down = pgm => {};
