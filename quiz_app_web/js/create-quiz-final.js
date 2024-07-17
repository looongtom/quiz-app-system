// Lấy phần tử button "Add Question"
const addQuestionButton = document.getElementById('add-question');

// Lấy phần tử section chứa các câu hỏi
const quizQuestionsSection = document.getElementById('quiz-questions');

// Số thứ tự câu hỏi ban đầu
let questionNumber = 1;

// Xử lý sự kiện khi nút "Thêm câu hỏi khác" được nhấn
addQuestionButton.addEventListener('click', function () {
  // Tạo phần tử HTML cho câu hỏi mới
  const questionDiv = document.createElement('div');
  questionDiv.classList.add('question');

  // Tạo phần tử label cho số thứ tự câu
  const questionNumberLabel = document.createElement('label');
  questionNumberLabel.setAttribute('for', 'question-number');
  questionNumberLabel.textContent = 'Số thứ tự câu:';
  questionDiv.appendChild(questionNumberLabel);

  // Tạo phần tử span cho số thứ tự câu
  const questionNumberSpan = document.createElement('span');
  questionNumberSpan.classList.add('question-number');
  questionNumberSpan.textContent = questionNumber;
  questionDiv.appendChild(questionNumberSpan);

  // Tạo phần tử label cho nội dung câu hỏi
  const questionTextLabel = document.createElement('label');
  questionTextLabel.setAttribute('for', 'question-text');
  questionTextLabel.textContent = 'Type question here';
  questionDiv.appendChild(questionTextLabel);

  // Tạo phần tử input cho nội dung câu hỏi
  const questionTextInput = document.createElement('input');
  questionTextInput.type = 'text';
  questionTextInput.classList.add('question-text');
  questionDiv.appendChild(questionTextInput);

  // Tạo phần tử label cho thời gian câu hỏi
  const questionTimeLabel = document.createElement('label');
  questionTimeLabel.setAttribute('for', 'question-time');
  questionTimeLabel.textContent = 'Chọn thời gian:';
  questionDiv.appendChild(questionTimeLabel);

  // Tạo phần tử select cho thời gian câu hỏi
  const questionTimeSelect = document.createElement('select');
  questionTimeSelect.classList.add('question-time');
  // Thêm các tùy chọn thời gian vào danh sách thả xuống
  const timeOptions = ['10', '15', '20', '30'];
  timeOptions.forEach(function (optionText) {
    const option = document.createElement('option');
    option.textContent = optionText;
    questionTimeSelect.appendChild(option);
  });

  questionDiv.appendChild(questionTimeSelect);

  // Tạo nút xóa câu hỏi
  const deleteQuestionButton = document.createElement('button');
  deleteQuestionButton.textContent = 'Delete question';
  deleteQuestionButton.classList.add('delete-question');
  questionDiv.appendChild(deleteQuestionButton);

  // Xử lý sự kiện khi nút "Xóa câu hỏi" được nhấn
  deleteQuestionButton.addEventListener('click', function () {
    questionDiv.remove(); // Xóa câu hỏi khi nút "Xóa câu hỏi" được nhấn
  });

  // Tạo ba câu trả lời
  for (let i = 1; i <= 3; i++) {
    // Tạo phần tử label cho câu trả lời
    const answerLabel = document.createElement('label');
    answerLabel.setAttribute('for', 'answer');
    answerLabel.textContent = 'Type answer here';
    questionDiv.appendChild(answerLabel);

    // Tạo phần tử input cho checkbox câu trả lời
    const answerCheckbox = document.createElement('input');
    answerCheckbox.type = 'checkbox';
    answerCheckbox.classList.add('answer-checkbox');
    questionDiv.appendChild(answerCheckbox);

    // Tạo phần tử input cho nội dung câu trả lời
    const answerInput = document.createElement('input');
    answerInput.type = 'text';
    answerInput.classList.add('answer-text');
    questionDiv.appendChild(answerInput);

    // Tạo nút xóa câu trả lời
    const deleteAnswerButton = document.createElement('button');
    deleteAnswerButton.textContent = 'Delete answer';
    deleteAnswerButton.classList.add('delete-answer');
    questionDiv.appendChild(deleteAnswerButton);

    // Xử lý sự kiện khi nút "Xóa câu trả lời" được nhấn
    deleteAnswerButton.addEventListener('click', function () {
      answerLabel.remove(); // Xóa label của câu trả lời
      answerCheckbox.remove(); // Xóa checkbox của câu trả lời
      answerInput.remove(); // Xóa input của câu trả lời
      deleteAnswerButton.remove(); // Xóa nút "Xóa câu trả lời"
    });
  }

  // Tạo phần tử button "Thêm câu trả lời"
  const addAnswerButton = document.createElement('button');
  addAnswerButton.classList.add('add-answer');
  addAnswerButton.textContent = 'Add answer';
  questionDiv.appendChild(addAnswerButton);

  // Xử lý sự kiện khi nút "Thêm câu trả lời" được nhấn
  addAnswerButton.addEventListener('click', function () {
    // Tạo phần tử label cho câu trả lời
    const answerLabel = document.createElement('label');
    answerLabel.setAttribute('for', 'answer');
    answerLabel.textContent = 'Type answer here:';
    questionDiv.insertBefore(answerLabel, addAnswerButton);

    // Tạo phần tử input cho checkbox câu trả lời
    const answerCheckbox = document.createElement('input');
    answerCheckbox.type = 'checkbox';
    answerCheckbox.classList.add('answer-checkbox');
    questionDiv.insertBefore(answerCheckbox, addAnswerButton);

    // Tạo phần tử input cho nội dung câu trả lời
    const answerInput = document.createElement('input');
    answerInput.type = 'text';
    answerInput.classList.add('answer-text');
    questionDiv.insertBefore(answerInput, addAnswerButton);

    // Tạo nút xóa câu trả lời
    const deleteAnswerButton = document.createElement('button');
    deleteAnswerButton.textContent = 'Delete answer';
    deleteAnswerButton.classList.add('delete-answer');
    questionDiv.insertBefore(deleteAnswerButton, addAnswerButton);

    // Xử lý sự kiện khi nút "Xóa câu trả lời" được nhấn
    deleteAnswerButton.addEventListener('click', function () {
      answerLabel.remove(); // Xóa label của câu trả lời
      answerCheckbox.remove(); // Xóa checkbox của câu trả lời
      answerInput.remove(); // Xóa input của câu trả lời
      deleteAnswerButton.remove(); // Xóa nút "Xóa câu trả lời"
    });
  });

  // Thêm câu hỏi vào phần tử chứa các câu hỏi
  quizQuestionsSection.appendChild(questionDiv);

  questionNumber++;
});

var participantList = [];

document.addEventListener("DOMContentLoaded", function () {
  // Lấy các phần tử DOM
  var participantForm = document.getElementById("participant-form");
  var participantInput = document.getElementById("participant-name");
  var addButton = document.querySelector("#add-participant");
  var participantDisplay = document.createElement("ul");
  participantForm.appendChild(participantDisplay);

  // Xử lý sự kiện khi nhấn nút "Thêm"
  addButton.addEventListener("click", function () {
    var participantName = participantInput.value.trim();
    if (participantName !== "") {
      // Thực hiện gọi API để lấy ID của người dùng dựa trên tên người dùng
      fetchUserId(participantName)
        .then(user => {
          if (user) {
            // Thêm tên người tham gia vào danh sách
            participantList.push(user);
            console.log(participantName)
            // Cập nhật hiển thị danh sách
            renderParticipantList();
            // Xóa nội dung trong input
            participantInput.value = "";
          } else {
            alert("Không tìm thấy người dùng với tên:", participantName);
          }
        })
        .catch(error => console.error(error));
    }
  });

  // Hàm gọi API để lấy ID của người dùng dựa trên tên người dùng
  function fetchUserId(username) {
    const myHeaders = new Headers();
    myHeaders.append("Authorization", 'Bearer ${token}');

    const requestOptions = {
      method: "GET",
      headers: myHeaders,
      redirect: "follow"
    };
      
    return fetch(`${protocol}//${host}:${port}/search/user-by-username?username=` + username, requestOptions)
      .then(response => response.json())
      .then(result => {
        if (result.status === 200 && result.data && result.data.id != 0) {
          return result.data;
        } else {
          return null;
        }
      })
      .catch(error => {
        console.error("Error:", error);
        return null;
      });
  }

  // Hàm cập nhật hiển thị danh sách người tham gia
  function renderParticipantList() {
    // Xóa nội dung cũ của danh sách
    participantDisplay.innerHTML = "";

    // Tạo các phần tử danh sách mới từ danh sách tên người tham gia
    participantList.forEach(function (user, index) {
      var listItem = document.createElement("li");
      listItem.textContent = user.username;

      // Tạo một nút hoặc biểu tượng "X" để xóa tên người tham gia
      var deleteButton = document.createElement("button");
      deleteButton.textContent = "x"; // Có thể sử dụng biểu tượng "X" thay vì chữ X
      deleteButton.id = "delete-button-" + index; // Tạo ID cho nút X
      deleteButton.addEventListener("click", function () {
        // Xóa tên người tham gia khỏi danh sách
        participantList.splice(index, 1);
        // Cập nhật lại hiển thị danh sách
        renderParticipantList();
        console.log(participantList);
      });

      // Thêm nút hoặc biểu tượng "X" vào phần tử danh sách
      listItem.appendChild(deleteButton);

      // Thêm phần tử danh sách vào danh sách hiển thị
      participantDisplay.appendChild(listItem);
    });
  }
});















// Lấy token từ local storage
const token = localStorage.getItem('token');

// Lắng nghe sự kiện click trên nút "Lưu câu hỏi"
const saveQuizButton = document.getElementById('save-quiz-button');
saveQuizButton.addEventListener('click', saveQuestions);

// Hàm xử lý khi nhấp vào nút "Lưu câu hỏi"
function saveQuestions() {
  // Lấy thông tin từ các trường input trong phần thông tin quiz
  const quizName = document.getElementById('quiz-name').value;
  const startTimeInput = document.getElementById('start-time');
  const endTimeInput = document.getElementById('end-time');
  const startTimeValue = startTimeInput.value;
  const endTimeValue = endTimeInput.value;

  // Chuyển đổi thành chuỗi dạng ISO 8601 (UTC)
  const startTimeISO = new Date(startTimeValue).toISOString();
  const endTimeISO = new Date(endTimeValue).toISOString();
  console.log("startAt:", startTimeISO);
  console.log("expireAt:", endTimeISO);
  // Lấy danh sách câu hỏi và câu trả lời
  const quizQuestions = document.getElementById('quiz-questions');
  const questions = quizQuestions.getElementsByClassName('question');

  let privacyOfQuiz = 'PUBLIC'
  // Kiểm tra nếu participantList không có phần tử nào
  if (participantList.length !== 0) {
    privacyOfQuiz = 'PRIVATE';
  }
  console.log(privacyOfQuiz);
  console.log(participantList.map((e) => e.id))

  // Tạo mảng chứa các câu hỏi và câu trả lời
  const data = {
    quiz: {
      name: quizName,
      startAt: startTimeISO,
      expireAt: endTimeISO,
      privacy: privacyOfQuiz,
      listUserId: participantList.map((e) => e.id)
    },

    listQuestion: []
  };

  // Lặp qua từng câu hỏi để lấy thông tin
  for (let i = 0; i < questions.length; i++) {
    const questionText = questions[i].querySelector('.question-text').value;
    const answers = questions[i].querySelectorAll('.answer-text');
    const timeInput = questions[i].querySelector('.question-time').value;
    const checkboxes = questions[i].querySelectorAll('.answer-checkbox');

    let checkedCount = 0;
    let questionType;

    // Đếm số checkbox được tích
    for (let j = 0; j < checkboxes.length; j++) {
      if (checkboxes[j].checked) {
        checkedCount++;
      }
    }

    // Xác định loại câu hỏi dựa vào số lượng checkbox được tích
    if (checkedCount === 1) {
      questionType = 'SINGLE_CHOICE';
    } else {
      questionType = 'MULTIPLE_CHOICE';
    }

    // Tạo mảng chứa các câu trả lời
    const answersData = [];

    // Lặp qua từng câu trả lời để lấy thông tin
    for (let k = 0; k < answers.length; k++) {
      const answer = answers[k].value;
      const isCorrect = checkboxes[k].checked;

      // Thêm câu trả lời vào mảng
      answersData.push({
        name: answer,
        isCorrect: isCorrect,
      });
    }

    // Thêm câu hỏi và câu trả lời vào mảng
    data.listQuestion.push({
      question: questionText,
      type: questionType, // Thêm loại câu hỏi vào dữ liệu
      time: parseInt(timeInput),
      answers: answersData
    });
  }
  var protocol = window.location.protocol;
  var host = "3.88.212.45";
  var port = "8080";

  // Gửi dữ liệu câu hỏi và câu trả lời lên API
  fetch(`${protocol}//${host}:${port}/api/v1/question/save-many-question`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify(data)
  })
    .then(response => response.json())
    .then(result => {
      // Xử lý kết quả từ API (nếu cần)
      console.log(result);

    })
    .catch(error => {
      // Xử lý lỗi (nếu có)
      console.log(error);
      alert('Tạo quiz lỗi: ' + error);
    });
}