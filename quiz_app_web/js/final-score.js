document.addEventListener("DOMContentLoaded", function () {
    var score = localStorage.getItem("finalScore");
    var userId;
    var username;
    var quizId = localStorage.getItem("quizId");
    var token = localStorage.getItem("token");

    fetchUserInfo();


   
    function fetchUserInfo() {
       
    
        fetch(`${protocol}//${host}:${portAuth}/auth/me`, {
            headers: {
                "Authorization": "Bearer " + token,
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    userId = data.data.id;
                    username = data.data.username;
                    submitScore();
                } else {
                    console.error("Failed to fetch user info.");
                }
            })
            .catch(error => {
                console.error("Error fetching user info:", error);
            });
    }

    function submitScore() {
        var protocol = window.location.protocol;
        var host = "3.88.212.45";
        var port = "8080";
    
        fetch(`${protocol}//${host}:${port}/api/v1/score/save-score`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token,
            },
            body: JSON.stringify({
                score: score,
                quizId: quizId,
                userId: userId,
                username: username,
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    console.log("Score submitted successfully.");
                    fetchLeaderboard();
                } else {
                    console.error("Failed to submit score.");
                }
            })
            .catch(error => {
                console.error("Error submitting score:", error);
            });
    }

    function fetchLeaderboard() {
        fetch(`${protocol}//${host}:${port}/api/v1/score/get-score-by-quiz?quizId=` + quizId, {
            headers: {
                "Authorization": "Bearer " + token,
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    displayLeaderboard(data.data);
                } else {
                    console.error("Failed to fetch leaderboard.");
                }
            })
            .catch(error => {
                console.error("Error fetching leaderboard:", error);
            });
    }

    function displayLeaderboard(scores) {
        // Clear existing leaderboard if needed
        var leaderboardTable = document.getElementById("leaderboard-body");
        leaderboardTable.innerHTML = "";

        // Populate leaderboard table with fetched scores
        scores.forEach(function (score, index) {
            var row = leaderboardTable.insertRow();
            var numberCell = row.insertCell(0);
            var usernameCell = row.insertCell(1);
            var dateCell = row.insertCell(2);
            var scoreCell = row.insertCell(3);

            numberCell.textContent = index + 1;
            usernameCell.textContent = score.username;
            dateCell.textContent = score.timestamp;
            scoreCell.textContent = score.score;
        });
    }
});
