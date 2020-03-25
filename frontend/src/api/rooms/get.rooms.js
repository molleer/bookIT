import { getRequest } from "../utils/api";

export const getRooms = () => getRequest("/room/");
