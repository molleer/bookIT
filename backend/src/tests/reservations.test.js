const assert = require("assert");
const { getPool, initDB, to } = require("../utils");
const { deleteReservation, addReservation } = require("../db/reservation.db");
const { deleteRoom, addRoom } = require("../db/room.db");
const { dummyReservations, dummyRooms, dummyUser } = require("./dummy.data");
const { createReservation } = require("../services/reservation.service");

const clearDummies = async () => {
    //Clear dummy reservations
    for (var i in dummyReservations) {
        const [err] = await to(deleteReservation(dummyReservations[i].id));
        if (err) console.log(err);
    }

    //Clears dummy rooms
    for (var i in dummyRooms) {
        const [err] = await to(deleteRoom(dummyRooms[i].id));
        if (err) console.log(err);
    }
};

describe("Creating reservation", () => {
    before(async () => {
        if (!getPool()) {
            initDB();
        }
        await clearDummies();
    });
    after(clearDummies);
    it("Should create rooms", async () => {
        var [err] = [];
        for (var i in dummyRooms) {
            [err] = await to(addRoom(dummyRooms[i].id, dummyRooms[i]));
            assert.strictEqual(err, null);
        }
    });
    it("Should create and delete reservation", async () => {
        var [err] = await to(
            addReservation(dummyReservations[0].id, dummyReservations[0])
        );
        assert.strictEqual(err, null);

        [err] = await to(deleteReservation(dummyReservations[0].id));
        assert.strictEqual(err, null);
    });
    it("Should create reservation", async () => {
        var [err] = [];
        for (var i in dummyReservations) {
            [err] = await createReservation(
                dummyUser,
                dummyReservations[i],
                dummyReservations[i].id
            );
            assert.strictEqual(err, null);
        }
    });
    it("Should fail to create reservation", async () => {
        //Reservation in the same time and room has already been done
        const [err, id] = await createReservation(
            dummyUser,
            dummyReservations[0]
        );
        if (id) {
            await to(deleteReservation(id));
        }
        assert.notStrictEqual(err, null);
    });
});
