


document.addEventListener("DOMContentLoaded", function () {
    var questions = JSON.parse(localStorage.getItem("quizQuestions"));
    var currentQuestionIndex = 0;
    var correctAnswers = 0;
    var wrongAnswers = 0;
    var totalQuestions = questions.length;
    var countdownTimer;
    var showingAnswer = false;

    var totalQuestionHtml = document.getElementById("total-questions");
    totalQuestionHtml.innerHTML = totalQuestions;

    function displayQuestion() {
        var currentQuestion = questions[currentQuestionIndex];
        var questionElement = document.querySelector(".question");
        var answersElement = document.querySelector(".answers");
        var submitButton = document.getElementById("submit-button");
        var timeLeftElement = document.getElementById("time-left");

        questionElement.textContent = "Câu " + (currentQuestionIndex + 1) + ": " + currentQuestion.question;
        answersElement.innerHTML = "";

        currentQuestion.answers.forEach(function (answer, index) {
            var li = document.createElement("li");
            var label = document.createElement("label");
            var input = document.createElement("input");
            input.type = currentQuestion.type === "SINGLE_CHOICE" ? "radio" : "checkbox";
            input.style.display = currentQuestion.type === "SINGLE_CHOICE" ? "none" : "flex";
            input.name = "answer";
            input.value = answer.id;
            label.appendChild(input);
            label.classList.add('single-choice');
            label.appendChild(document.createTextNode(answer.name));
            li.appendChild(label);
            answersElement.appendChild(li);
        });

        submitButton.style.display = currentQuestion.type === "MULTIPLE_CHOICE" ? "block" : "none";
        submitButton.disabled = true;

        var timeLeft = currentQuestion.time;
        clearInterval(countdownTimer);
        countdownTimer = setInterval(function () {
            timeLeftElement.textContent = formatTime(timeLeft);
            if (timeLeft === 0) {
                clearInterval(countdownTimer);
                if (!showingAnswer) {
                    showCorrectAnswers();
                }
            }
            timeLeft--;
        }, 1000);
    }

    function formatTime(time) {
        var minutes = Math.floor(time / 60);
        var seconds = time % 60;
        return minutes.toString().padStart(2, "0") + ":" + seconds.toString().padStart(2, "0");
    }

    function showCorrectAnswers() {
        clearInterval(countdownTimer);
        var currentQuestion = questions[currentQuestionIndex];
        var selectedAnswers = Array.from(document.querySelectorAll('input[name="answer"]:checked')).map(input => input.value);
        var correctAnswersIds = currentQuestion.answers.filter(answer => answer.correct).map(answer => answer.id);
        var correctAnswersElement = document.getElementById("correct-answers");
        var wrongAnswersElement = document.getElementById("wrong-answers");
        var progressBar = document.getElementById("progress-bar");

        var progress = ((currentQuestionIndex + 1) / totalQuestions) * 100;
        progressBar.style.width = progress + "%";

        if (selectedAnswers.length === 0) {
            wrongAnswers++;
        } else {
            // Check if all selected answers match all correct answers
            var allCorrect = selectedAnswers.every(answerId => correctAnswersIds.includes(parseInt(answerId)));
            if (allCorrect && selectedAnswers.length === correctAnswersIds.length) {
                correctAnswers++;
            } else {
                wrongAnswers++;
            }
        }

        correctAnswersElement.textContent = correctAnswers;
        wrongAnswersElement.textContent = wrongAnswers;

        currentQuestion.answers.forEach(function (answer) {
            var answerElement = document.querySelector('input[value="' + answer.id + '"]').parentNode;
            if (answer.correct) {
                answerElement.classList.add("correct");
            } else {
                if (selectedAnswers.includes(answer.id.toString())) {
                    answerElement.classList.add("wrong");
                }
            }
        });

        showingAnswer = true;
        setTimeout(function () {
            currentQuestionIndex++;
            if (currentQuestionIndex < totalQuestions) {
                displayQuestion();
                showingAnswer = false;
            } else {
                alert("End of quiz!");
                redirectToFinalScore();
            }
        }, 1500);
    }

    document.getElementById("submit-button").addEventListener("click", function () {
        if (!showingAnswer) {
            showCorrectAnswers();
            this.disabled = true;
        }
    });

    function redirectToFinalScore() {
        var score = Math.round((correctAnswers / totalQuestions) * 100);
        localStorage.setItem("finalScore", score);
        window.location.href = "final-score.html";
    }

    document.querySelector(".answers").addEventListener("change", function () {
        var submitButton = document.getElementById("submit-button");
        var anyAnswerSelected = Array.from(document.querySelectorAll('input[name="answer"]:checked')).length > 0;

        if (submitButton) {
            submitButton.disabled = !anyAnswerSelected;
            submitButton.style.opacity = anyAnswerSelected ? 1 : 0.6;

            var currentQuestion = questions[currentQuestionIndex];
            if (currentQuestion.type === "SINGLE_CHOICE" && anyAnswerSelected) {
                showCorrectAnswers();
            }
        }
    });

    displayQuestion();
});
