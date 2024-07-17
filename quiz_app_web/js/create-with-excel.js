document.addEventListener("DOMContentLoaded", function () {
    const fileInput = document.getElementById("excelFile");
    const quizNameInput = document.getElementById("quizName");
    const importButton = document.getElementById("save-quiz");
  
    fileInput.addEventListener("change", handleFileSelect);
    importButton.addEventListener("click", importFile);
  
    let selectedFile = null;
  
    function handleFileSelect(event) {
      selectedFile = event.target.files[0];
    }
  
    function importFile() {
      const quizName = quizNameInput.value;
      const token = localStorage.getItem("token");
  
      if (selectedFile && quizName && token) {
        const myHeaders = new Headers();
        myHeaders.append("Authorization", `Bearer ${token}`);
  
        const formdata = new FormData();
        formdata.append("file", selectedFile);
        formdata.append("numberOfSheet", "1");
        formdata.append("quizName", quizName);
  
        const requestOptions = {
          method: "POST",
          headers: myHeaders,
          body: formdata,
          redirect: "follow",
        };
  
        fetch(`${protocol}//${host}:${port}/api/v1/file/upload`, requestOptions)
          .then((response) => response.text())
          .then((result) => {
            console.log(result);
            // Perform actions after successful upload
          })
          .catch((error) => console.error(error));
      } else {
        console.log("Please select an Excel file, enter a quiz name, and authenticate.");
      }
    }
  });