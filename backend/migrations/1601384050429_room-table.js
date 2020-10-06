/* eslint-disable camelcase */

exports.shorthands = undefined;

exports.up = pgm => {
    pgm.createExtension("uuid-ossp");
    pgm.createTable("room", {
        id: {
            type: "uuid",
            primaryKey: true,
            default: pgm.func("uuid_generate_v1()"),
        },
        name: {
            type: "text",
            notNull: true,
        },
    });
};

exports.down = pgm => {};
