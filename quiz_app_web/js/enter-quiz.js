document.addEventListener("DOMContentLoaded", function () {
    // Function to handle API call
    function enterQuiz() {
        var quizId = document.getElementById("quiz-id").value;
        var xhr = new XMLHttpRequest();
        const token = localStorage.getItem('token');

        xhr.open("GET", `${protocol}//${host}:${port}/api/v1/question/get-question-by-quiz?quizId=` + quizId, true);
        xhr.setRequestHeader("Authorization", "Bearer " + token);

        xhr.onload = function () {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                var data = response.data;
                // Save questions entity
                var questions = data.questions;
                localStorage.setItem("quizQuestions", JSON.stringify(questions));
                localStorage.setItem("quizId", quizId);
                // Redirect to do-quiz.html
                window.location.href = "do-quiz.html";
            } else {
                var errorResponse = JSON.parse(xhr.responseText);
                var errorMessage = errorResponse.message;
                // Show alert dialog with error message
                alert(errorMessage);
            }
        };

        xhr.onerror = function () {
            // Show alert dialog for any network errors
            alert("Failed to connect to the server.");
        };

        xhr.send();
    }

    // Event listener for button click
    document.getElementById("enter-quiz-button").addEventListener("click", enterQuiz);
});
