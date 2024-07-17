document.getElementById("btn-create-quiz").addEventListener("click", function() {
    // Chuyển hướng sang trang create-question.html
    window.location.href = "create-quiz.html";
  });

  document.getElementById("btn-create-quiz-with-excel").addEventListener("click", function() {
    // Chuyển hướng sang trang create-question.html
    window.location.href = "create-quiz-with-excel.html";
  });



const logoutButton = document.querySelector("#logout-button");
logoutButton.addEventListener("click", () => {
    const myHeaders = new Headers();
    myHeaders.append("Authorization", "Bearer " + localStorage.getItem("token"));

    const requestOptions = {
        method: "POST",
        headers: myHeaders,
        redirect: "follow"
    };

   

    fetch(`${protocol}//${host}:${portAuth}/auth/logout`, requestOptions)
        .then((response) => response.text())
        .then((result) => {
            console.log(result);
            window.location.href = 'login.html';
            // Xử lý kết quả trả về sau khi đăng xuất
        })
        .catch((error) => console.error(error));
});


function fetchUserInfo() {
  // Fetch the JSON data
  const token = localStorage.getItem('token');

  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");
  myHeaders.append("Authorization", "Bearer " + token);

  const requestOptions = {
    method: "GET",
    headers: myHeaders,
    redirect: "follow",
  };

  fetch(`${protocol}//${host}:${portAuth}/auth/me`, requestOptions)
    .then(response => response.json())
    .then(data => {
      // Get the ul element
      const username = document.querySelector('#username');
      console.log(data.data.username)
      username.innerHTML = data.data.username
    });
}