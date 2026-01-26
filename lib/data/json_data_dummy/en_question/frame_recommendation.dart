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
          {"label": "<18", "value": "Under 18 years old"},
          {"label": "18-25", "value": "18-25 years old"},
          {"label": "26-39", "value": "26-39 years old"},
          {"label": "40-50", "value": "40-50 years old"},
          {"label": "51+", "value": "Over 51 years old"},
        ],
      },
      {
        "id": "gender",
        "step": 2,
        "question": "How can we identify you?",
        "type": "single_choice",
        "options": [
          {"label": "men", "value": "Men"},
          {"label": "women", "value": "Women"},
          {"label": "prefer_not_to_say", "value": "I prefer not to say"},
        ],
      },
    ],
  };
}
