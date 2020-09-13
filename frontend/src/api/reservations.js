import { getRequest } from "./utils/api";

export const getReservations = () => getRequest("/reservation/");

export const getReservation = id => getRequest("/reservation/" + id);
