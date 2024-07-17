function callAPI(url, method,  data=null, handler) {
    if (data instanceof FormData) {
        console.log(data.get('jsonData'));
    }
    apiUrl = `${prefixUrl}${url}`;
    accessToken = localStorage.getItem('accessToken') ? localStorage.getItem('accessToken') : 'abcxyz';

    const xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    xhr.addEventListener("readystatechange", handler);

    xhr.open(method, apiUrl, true);
    xhr.setRequestHeader("Authorization", `Bearer ${accessToken}`);
    xhr.send(data);
}