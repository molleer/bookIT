import axios from "axios";
import _ from "lodash";

const path = "/api";

export function getRequest(endpoint) {
    var headers = {};

    // if (includeAuthorization) {
    //   headers = {
    //     Authorization: "Bearer " + token()
    //   };
    // }

    return new Promise((resolve, reject) => {
        axios
            .get(removeLastSlash(path + endpoint), {
                headers,
            })
            .then(response => resolve(response))
            .catch(error => {
                if (error.response != null) {
                    console.log(error.response.data);
                    console.log(error.response.status);
                    if (error.response.status === 403) {
                        localStorage.setItem(
                            "currentPage",
                            window.location.href
                        );
                        window.location.href = error.response.data;
                    }
                } else {
                    console.log(error);
                }
                reject(error);
            });
    });
}

export function postRequest(endpoint, data) {
    var headers = {};

    // if (includeAuthorization) {
    //   headers = {
    //     Authorization: "Bearer " + token()
    //   };
    // }

    return axios.post(removeLastSlash(path + endpoint), data, {
        headers,
    });
}

export function deleteRequest(endpoint, data) {
    var headers = {};

    // if (includeAuthorization) {
    //   headers = {
    //     Authorization: "Bearer " + token()
    //   };
    // }

    return axios.delete(removeLastSlash(path + endpoint), {
        data: data,
        headers,
    });
}

export function putRequest(endpoint, data) {
    var headers = {};

    // if (includeAuthorization) {
    //   headers = {
    //     Authorization: "Bearer " + token()
    //   };
    // }

    return axios.put(removeLastSlash(path + endpoint), data, {
        headers,
    });
}

function removeLastSlash(path) {
    return _.trimEnd(path, "/");
}

/*function token() {
  return null;
}*/
