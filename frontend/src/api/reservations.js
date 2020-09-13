import { getRequest, postRequest } from "./utils/api";

export const getReservations = () => getRequest("/reservation/");

export const getReservation = id => getRequest("/reservation/" + id);

export const createReservation = data => postRequest("/reservation/", data);
