document.getElementById("save-button").addEventListener("click", saveQuestion);

function saveQuestion() {
  const quizName = document.getElementById("quiz-name").value;
  const questionInput = document.getElementById("question-input").value;
  const answerInputs = document.querySelectorAll('input[name="correct-answer"]');
  const timeSelect = document.getElementById("time-select");

  // Kiểm tra trường trống
  if (quizName === '' || questionInput === '' || answerInputs.length === 0) {
    alert('Vui lòng điền đầy đủ thông tin câu hỏi.');
    return;
  }

  const answers = [];
  answerInputs.forEach((input) => {
    const answerId = parseInt(input.value);
    const answerText = document.getElementById(`answer${answerId}-input`).value;
    const isCorrect = input.checked;
    answers.push({ name: answerText, correct: isCorrect });
  });

  const time = parseInt(timeSelect.value);

  let questionType = "MULTIPLE_CHOICE";
  const checkedAnswerCount = answers.filter((answer) => answer.correct).length;
  if (checkedAnswerCount === 1) {
    questionType = "SINGLE_CHOICE";
  }

  const questionData = {
    question: questionInput,
    type: questionType,
    time: time,
    answers: answers,
  };

  const requestData = {
    quizName: quizName,
    listQuestion: [questionData],
  };

  const token = localStorage.getItem('token');

  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");
  myHeaders.append("Authorization", "Bearer " + token);

  const requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: JSON.stringify(requestData),
    redirect: "follow",
  };

  fetch(
    `${protocol}//${host}:${port}/api/v1/question/save-many-question`,
    requestOptions
  )
    .then((response) => {
      if (response.status === 200) {
        alert(`Tạo "${quizName}" thành công.`);
        window.location.href = "home.html";
      } else {
        throw new Error('Lưu câu hỏi không thành công.');
      }
    })
    .catch((error) => console.error(error));
}





document.addEventListener('DOMContentLoaded', function () {
  var addQuestionButton = document.getElementById('add-question-button');
  addQuestionButton.addEventListener('click', function () {
    addQuestion();
  });
});

function addQuestion() {
  var questionContainer = document.querySelector('.question-container');

  var newQuestionContainer = document.createElement('div');
  newQuestionContainer.classList.add('question-container');

  var questionLabel = document.createElement('label');
  questionLabel.htmlFor = 'question-input';
  questionLabel.textContent = 'Type question here:';

  var questionTextarea = document.createElement('textarea');
  questionTextarea.id = 'question-input';
  questionTextarea.rows = '4';
  questionTextarea.placeholder = 'Enter your question';

  newQuestionContainer.appendChild(questionLabel);
  newQuestionContainer.appendChild(questionTextarea);

  var answerContainer = document.querySelector('.answer-container');
  var newAnswerContainer = answerContainer.cloneNode(true);

  newQuestionContainer.appendChild(newAnswerContainer);

  var timeContainer = document.querySelector('.time-container');
  var newTimeContainer = timeContainer.cloneNode(true);

  newQuestionContainer.appendChild(newTimeContainer);

  var saveButton = document.getElementById('save-button');
  saveButton.parentNode.insertBefore(newQuestionContainer, saveButton);
}