var btnRegister = document.querySelector("#btn-register");
btnRegister.addEventListener("click", function () {
    var username = document.querySelector('input[name="username"]').value;
    var password = document.querySelector('input[name="password"]').value;
    var email = document.querySelector('input[name="email"]').value;
    var role = document.querySelector('input[name="role"]').value;

    // var payload = {
    //     username: username,
    //     password: password,
    //     email: email,
    //     roles: role
    // };

    const formdata = new FormData();
    formdata.append("username", username);
    formdata.append("password", password);
    formdata.append("email", email);
    formdata.append("roles", role);

    const requestOptions = {
        method: "POST",
        body: formdata,
        redirect: "follow"
    };
    
    fetch(`${protocol}//${host}:${portAuth}/auth/register`, requestOptions)
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (data.status === 201) {
                alert(data.message);
                window.location.href = 'login.html';
            } else {
                alert('Đăng ký không thành công. Vui lòng thử lại.');
            }
        })
        .catch(function (error) {
            console.error('Lỗi:', error);
        });
})