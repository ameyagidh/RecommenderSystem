var profileTab = document.getElementById("profile-tab");
var historyTab = document.getElementById("history-tab");
var recommendationTab = document.getElementById("recommendation-tab");
var profileBlock = document.getElementById("profileResult");
var historyBlock = document.getElementById("historyResult");
var recommendationBlock = document.getElementById("recommendation");
var submitRecommendationForm = document.getElementById("submitRecommendation");
var recommendationResultBlock = document.getElementById("recommendationResult");
var loadingButton = document.getElementById("loadingButton");


function loadHistoryTab() {
    historyTab.click();
}

profileTab.addEventListener("click", function () {
    fetch("home/profile", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
        //body: ""
    }).then(function (res) {
        return res.text();
    }).then(function (resultHTML) {
        profileBlock.innerHTML = resultHTML;
    }).catch(function (err) {
        console.log(err);
    });
});

historyTab.addEventListener("click", function () {
    fetch("home/history", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
        //body: ""
    }).then(function (res) {
        return res.text();
    }).then(function (resultHTML) {
        historyBlock.innerHTML = resultHTML;
    }).catch(function (err) {
        console.log(err);
    });
});

recommendationTab.addEventListener("click", function () {
    submitRecommendationForm.hidden = false;
    loadingButton.hidden = true;
    recommendationResultBlock.hidden = true;
    recommendationResultBlock.innerHTML = "";
});


submitRecommendationForm.addEventListener("submit", function (event) {
    event.preventDefault();
    submitRecommendationForm.hidden = true;
    loadingButton.hidden = false;
    // get original form data entries
    var formData = new FormData(submitRecommendationForm);
    var formDataEntries = Object.fromEntries(formData.entries())

    fetch(event.target.action, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(formDataEntries)
    }).then(function (res) {
        return res.text();
    }).then(function (resultHTML) {
        loadingButton.hidden = true;
        recommendationResultBlock.hidden = false;
        recommendationResultBlock.innerHTML = resultHTML;
    }).catch(function (err) {
        console.log(err);
    });
});


function showDescription(courseSelected) {
    var courseDescriptions = document.getElementById("courseDescriptions").children;
    //console.log(courseDescriptions[0]);
    for (idx = 0; idx < courseDescriptions.length; idx++) {
        if (courseSelected.value == courseDescriptions[idx].id.replace("courseId", "")) {
            console.log(courseDescriptions[idx]);
            courseDescriptions[idx].hidden = false;
        } else {
            courseDescriptions[idx].hidden = true;
        }
    }
}