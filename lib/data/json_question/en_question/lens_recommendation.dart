class LensRecommendationDummyData {
  var lensQuestionData = {
    "formTitle": "Lens Recommendation Questionnaire",
    "type": "lens",
    "version": "1.0",
    "totalSteps": 12,
    "questions": [
      {
        "id": "minus_power",
        "step": 3,
        "question": "Do you have minus power (distance) for any of your eyes?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Not Sure"},
          {"label": "0.00_to_-2.00", "value": "0.00 to -2.00"},
          {"label": "-2.00_to_-4.00", "value": "-2.00 to -4.00"},
          {"label": "-4.00_to_-6.00", "value": "-4.00 to -6.00"},
          {"label": "below_-6.00", "value": "Below -6.00"},
        ],
      },
      {
        "id": "plus_power",
        "step": 4,
        "question":
            "Do you have plus power (reading support) for any of your eyes?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Not Sure"},
          {"label": "0.00", "value": "0.00"},
          {"label": "+0.50_to_+1.00", "value": "+0.50 to +1.00"},
          {"label": "+1.00_to_+2.00", "value": "+1.00 to +2.00"},
          {"label": "above_+2.00", "value": "Above +2.00"},
        ],
      },
      {
        "id": "astigmatism",
        "step": 5,
        "question": "Do you have astigmatism (cylinder)?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Not Sure"},
          {"label": "0.00", "value": "0.00"},
          {"label": "−0.25_to_−1.00", "value": "−0.25 to −1.00"},
          {"label": "−1.00_to_−2.00", "value": "−1.00 to −2.00"},
          {"label": "Below_−2.00", "value": "Below −2.00"},
        ],
      },
      {
        "id": "wearing_purpose",
        "step": 6,
        "question": "Where do you use/will you use your glasses the most?",
        "type": "single_choice",
        "options": [
          {"label": "mostly_indoor", "value": "Mostly outdoor"},
          {"label": "mostly_indoor", "value": "Mostly indoor"},
          {"label": "balance", "value": "Balance"},
          {"label": "screen_focused", "value": "Screen-focused"},
        ],
      },
      {
        "id": "important_distance",
        "step": 7,
        "question": "Which distance is most important for you to see clearly?",
        "type": "single_choice",
        "options": [
          {
            "label": "near_distance_clarity",
            "value": "Long distance clarity (e.g., driving, outdoor)",
          },
          {
            "label": "intermediate_distance_clarity",
            "value": "Intermediate distance focus",
          },
          {
            "label": "near_distance_clarity",
            "value": "Near distance clarity (e.g., reading, screen use)",
          },
          {
            "label": "all_distance_clarity",
            "value":
                "Balanced: All distance are equally important (e.g., no compromise)",
          },
        ],
      },
      {
        "id": "digital_eye_fatigue",
        "step": 8,
        "question":
            "How frequently do you experience eye fatigue during prolonged use of digital devices (phones, computers, tablets)?",
        "type": "single_choice",
        "options": [
          {"label": "never", "value": "Never"},
          {"label": "sometimes", "value": "Sometimes"},
          {"label": "often", "value": "Often"},
          {"label": "almost_always", "value": "Almost Always"},
        ],
      },
      {
        "id": "uv_protection_importance",
        "step": 9,
        "question":
            "How important is protection from sunlight and UV rays for you?",
        "type": "single_choice",
        "options": [
          {"label": "not_important", "value": "Not important"},
          {"label": "slightly_important", "value": "Slightly important"},
          {"label": "important", "value": "Important"},
          {"label": "very_important", "value": "Very important"},
          {"label": "extremely_important", "value": "Extremely important"},
        ],
      },
      {
        "id": "light_sensitivity",
        "step": 10,
        "question":
            "How sensitive are your eyes to bright lights or glare (for example, headlights or strong lighting)?",
        "type": "single_choice",
        "options": [
          {"label": "never", "value": "Never"},
          {"label": "sometimes", "value": "Sometimes"},
          {"label": "often", "value": "Often"},
          {"label": "almost_always", "value": "Almost Always"},
        ],
      },
      {
        "id": "impact_resistance_importance",
        "step": 11,
        "question":
            "How important is it for your lenses to be strong and resistant to impact (for sports, kids, or active use)?",
        "type": "single_choice",
        "options": [
          {"label": "not_needed", "value": "Not needed"},
          {"label": "nice_to_have", "value": "Nice to have"},
          {"label": "somewhat_important", "value": "Somewhat important"},
          {"label": "very_important", "value": "Very important"},
          {"label": "must_have", "value": "Must have"},
        ],
      },
      {
        "id": "budget_preference",
        "step": 12,
        "question": "Which best describes what you want?",
        "type": "single_choice",
        "options": [
          {"label": "most_affordable", "value": "Most affordable"},
          {
            "label": "good_quality_reasonable_price",
            "value": "Good quality, reasonable price",
          },
          {"label": "premium_performance", "value": "Premium performance"},
        ],
      },
    ],
  };
}
