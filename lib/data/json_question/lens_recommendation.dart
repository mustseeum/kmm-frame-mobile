class LensRecommendationDummyData {
  var lensQuestionData = {
    "formTitle": "Lens Recommendation Questionnaire",
    "type": "lens",
    "version": "1.0",
    "totalSteps": 5,
    "questions": [
      {
        "id": "prescription_history",
        "step": 1,
        "question": "Have you worn any kind of prescription before?",
        "type": "single_choice",
        "options": [
          {"label": "yes_occasional", "value": "Yes, occasionally"},
          {
            "label": "yes_regular",
            "value": "Yes, I wear glasses / contact lenses regularly",
          },
          {
            "label": "no_first_time",
            "value": "No, this would be my first pair",
          },
        ],
      },
      {
        "id": "daily_visual_activity",
        "step": 2,
        "question": "What best describes your main daily visual activity?",
        "type": "single_choice",
        "options": [
          {"label": "screen_near", "value": "Screen-based and near work"},
          {
            "label": "reading_detailed_manual",
            "value": "Reading or detailed manual work",
          },
          {
            "label": "mixed_near_far",
            "value": "Mixed activities (near and far)",
          },
          {
            "label": "mobility_distance",
            "value": "Mobility and distance focused activities",
          },
          {
            "label": "physical_active",
            "value": "Physical, active, or sport-focused activities",
          },
        ],
      },
      {
        "id": "daily_eye_usage",
        "step": 3,
        "question": "How many hours per day do you use your eyes intensively?",
        "type": "single_choice",
        "options": [
          {"label": "less_than_4", "value": "Less than 4 hours"},
          {"label": "4_to_8", "value": "4–8 hours"},
          {"label": "more_than_8", "value": "More than 8 hours"},
        ],
      },
      {
        "id": "focus_switch",
        "step": 4,
        "question":
            "How often do you switch focus or environment during the day?",
        "type": "single_choice",
        "options": [
          {
            "label": "screen_people_documents",
            "value": "Screen ↔ People ↔ Documents",
          },
          {"label": "near_far", "value": "Near ↔ Far vision"},
          {"label": "indoor_outdoor", "value": "Indoor ↔ Outdoor"},
          {"label": "rarely_switch", "value": "Rarely switch focus"},
        ],
      },
      {
        "id": "typical_environment",
        "step": 5,
        "question": "What best describes your typical environment?",
        "type": "single_choice",
        "options": [
          {
            "label": "air_conditioned_indoor",
            "value": "Air-conditioned indoor space",
          },
          {
            "label": "bright_dim_artificial",
            "value": "Bright or dim artificial lighting",
          },
          {
            "label": "strong_reflections_glare",
            "value": "Strong reflections or glare",
          },
          {
            "label": "high_contrast_lighting",
            "value": "High contrast lighting",
          },
          {
            "label": "hot_dusty_harsh_outdoor",
            "value": "Hot, dusty or harsh outdoor conditions",
          },
        ],
      },
    ],
  };
}
