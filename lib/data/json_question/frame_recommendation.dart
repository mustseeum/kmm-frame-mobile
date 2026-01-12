class FrameRecommendationDummyData {
  var frameQuestionData = {
    "formTitle": "Frame Recommendation Questionnaire",
    "type": "frame",
    "version": "1.0",
    "totalSteps": 4,
    "questions": [
      {
        "id": "age",
        "step": 1,
        "question": "How old are you?",
        "type": "single_choice",
        "options": [
          {"label": "age_6_17_04", "value": "6-17 years old"},
          {"label": "age_18_39_05", "value": "18-39 years old"},
          {"label": "age_40_50_06", "value": "40-50 years old"},
          {"label": "age_51_plus_07", "value": "51+ years old"},
        ],
      },
      {
        "id": "gender",
        "step": 2,
        "question": "How can we identify you?",
        "type": "single_choice",
        "options": [
          {"label": "men_01", "value": "Men"},
          {"label": "women_02", "value": "Women"},
          {"label": "non_binary_03", "value": "I prefer not to say"},
        ],
      },
    ],
  };
}
