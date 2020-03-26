import { putRequest } from "../utils/api";

export const updateRoom = (id, data) => putRequest("/room/" + id, data);
