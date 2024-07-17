document.getElementById('file-input').addEventListener('click', function () {
  var fileInput = document.getElementById('file-upload');
  var file = fileInput.files[0];
  const formData = new FormData();
  formData.append('file', file);
  formData.append('numberOfSheet', 1);
  const token = localStorage.getItem('token');

  fetch(`${protocol}//${host}:${port}/api/v1/file/upload-preview`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`
    },
    body: formData,
    redirect: "follow",
  })
    .then(response => response.json())
    .then(result => {
      // Xử lý kết quả từ API (nếu cần)
      console.log(result);

      result.listQuestion.forEach(function (questionData) {
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
        questionTextInput.value = questionData.question;
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
        questionTimeSelect.value = questionData.time.toString();
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

        for (let i = 0; i < questionData.answers.length; i++) {
          // Your existing code to create a new answer goes here
          // Tạo phần tử label cho câu trả lời
          const answerLabel = document.createElement('label');
          answerLabel.setAttribute('for', 'answer');
          answerLabel.textContent = 'Type answer here';
          questionDiv.appendChild(answerLabel);

          // Tạo phần tử input cho checkbox câu trả lời
          const answerCheckbox = document.createElement('input');
          answerCheckbox.type = 'checkbox';
          answerCheckbox.classList.add('answer-checkbox');
          answerCheckbox.checked = questionData.answers[i].isCorrect;
          questionDiv.appendChild(answerCheckbox);
          // Set the answer input's value to the answer name from the questionData

          // Tạo phần tử input cho nội dung câu trả lời
          const answerInput = document.createElement('input');
          answerInput.type = 'text';
          answerInput.classList.add('answer-text');
          answerInput.value = questionData.answers[i].name;
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
          // Set the answer checkbox's checked state to the isCorrect value from the questionData
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

    })
    .then(data => console.log(data))
    .catch(error => console.error('Error:', error));
});

// JavaScript
let width = 0;
let loadingBar = document.getElementById('loading-bar');
let milestone1 = document.getElementById('milestone1');
let milestone2 = document.getElementById('milestone2');
let milestone3 = document.getElementById('milestone3');

// let loadingInterval = setInterval(function () {
//   if (width >= 100) {
//     clearInterval(loadingInterval);
//   } else {
//     width++;
//     loadingBar.style.width = width + '%';
//     if (width >= 33) milestone1.style.backgroundColor = '#000000';
//     if (width >= 66) milestone2.style.backgroundColor = '#000000';
//     if (width >= 100) milestone3.style.backgroundColor = '#000000';
//   }
// }, 100);



const eventSource = new EventSource( `${protocol}//${host}:8083/sse`);

let milestone1Running = false;
let milestone2Running = false;

eventSource.onmessage = (event) => {
  const div = document.createElement("div");
  console.log(event.data);
  // div.textContent = `Event received: ${event.data}`;
  // document.getElementById("events").appendChild(div);

  if (event.data === "Service quiz is running") {
    loadingInterval = setInterval(function () {
      if (width >= 33) {
        // clearInterval(loadingInterval);
        milestone1.style.backgroundColor = '#000000';
      } else {
        width++;
        loadingBar.style.width = width + '%';
      }
    }, 100);
  } else if (event.data === "Service quiz runs successfully") {
    // clearInterval(loadingInterval);
  }
  else if (event.data === "Default") {
    return;
  }
  else if (event.data === "Service question is running") {
    loadingInterval = setInterval(function () {
      if (width >= 66) {
        // clearInterval(loadingInterval);
        milestone2.style.backgroundColor = '#000000';
      } else {
        width++;
        loadingBar.style.width = width + '%';
      }
    }, 100);
  } else if (event.data === "Service question runs successfully") {
    loadingInterval = setInterval(function () {
      if (width >= 100) {
        // clearInterval(loadingInterval);
        milestone3.style.backgroundColor = '#000000';
      } else {
        width++;
        loadingBar.style.width = width + '%';
      }
    }, 100);
    // JavaScript
  }

};

eventSource.onerror = (error) => {
  console.error("Error occurred:", error);
  eventSource.close();
};


window.onload = function() {
  fetch(`${protocol}//${host}:8083/send-message?message=Default`)
    .then(response => response.json())
    .then(data => console.log(data))
    .catch((error) => {
      console.error('Error:', error);
    });
};