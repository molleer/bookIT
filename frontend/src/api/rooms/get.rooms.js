import { getRequest } from "../utils/api";

export const getRooms = () => getRequest("/room/");

export const getRoom = id => getRequest("/room/" + id);
