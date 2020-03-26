import { postRequest } from "../utils/api";

export const createRoom = data => postRequest("/room/", data);
