const {
    handleGetRooms,
    handleGetRoom,
    handleAddRoom,
    handleEditRoom,
    handleDeleteRoom,
} = require("../controllers/room.controller");

const getRoomRoutes = router => {
    router.get("/room", handleGetRooms);
    router.get("/room/:id", handleGetRoom);
    router.post("/room", handleAddRoom);
    router.put("/room/:id", handleEditRoom);
    router.delete("/room/:id", handleDeleteRoom);
    return router;
};

module.exports = getRoomRoutes;
