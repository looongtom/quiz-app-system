var btnLogin = document.querySelector("#btn-login");
btnLogin.addEventListener("click", function () {
    var username = document.querySelector('input[name="username"]').value;
    var password = document.querySelector('input[name="password"]').value;


    const formdata = new FormData();
    formdata.append("username", username);
    formdata.append("password", password);

    const requestOptions = {
        method: "POST",
        body: formdata,
        redirect: "follow"
    };

  

    fetch( `${protocol}//${host}:${portAuth}/auth/login`, requestOptions)
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (data.status === 200) {
                alert(data.message);
                localStorage.setItem("token", data.data.token);
                window.location.href = 'home.html';
            } else {
                alert(data.error);
            }
        })
        .catch(function (error) {
            console.error('Lỗi:', error);
        });
})