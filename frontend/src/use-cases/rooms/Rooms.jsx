import { useEffect, useState } from "react";
import { getRooms } from "../../api/rooms/get.rooms";

const Rooms = () => {
  const [rooms, setRooms] = useState(null);

  useEffect(() => {
    getRooms().then(response => setRooms(response.data));
  }, []);

  console.log(rooms);

  return null;
};

export default Rooms;
