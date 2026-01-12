class LensRecommendationDummyData {
  var lensQuestionData = {
    "formTitle": "Lens Recommendation Questionnaire",
    "type": "lens",
    "version": "1.0",
    "totalSteps": 4,
    "questions": [
      {
        "id": "prescription_history",
        "step": 1,
        "question": "Have you worn any kind of prescription before?",
        "type": "single_choice",
        "options": [
          {"label": "Yes, occasionally", "value": "yes_occasional"},
          {
            "label": "Yes, I wear glasses / contact lenses regularly",
            "value": "yes_regular",
          },
          {
            "label": "No, this would be my first pair",
            "value": "no_first_time",
          },
        ],
      },
      {
        "id": "daily_visual_activity",
        "step": 2,
        "question": "What best describes your main daily visual activity?",
        "type": "single_choice",
        "options": [
          {"label": "Screen-based and near work", "value": "screen_near"},
          {
            "label": "Reading or detailed manual work",
            "value": "reading_detail",
          },
          {
            "label": "Mixed activities (near and far)",
            "value": "mixed_near_far",
          },
          {
            "label": "Mobility and distance focused activities",
            "value": "mobility_distance",
          },
          {
            "label": "Physical, active, or sport-focused activities",
            "value": "physical_active",
          },
        ],
      },
      {
        "id": "daily_eye_usage",
        "step": 3,
        "question": "How many hours per day do you use your eyes intensively?",
        "type": "single_choice",
        "options": [
          {"label": "Less than 4 hours", "value": "less_than_4"},
          {"label": "4–8 hours", "value": "4_to_8"},
          {"label": "More than 8 hours", "value": "more_than_8"},
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
            "label": "Screen ↔ People ↔ Documents",
            "value": "screen_people_documents",
          },
          {"label": "Near ↔ Far vision", "value": "near_far"},
          {"label": "Indoor ↔ Outdoor", "value": "indoor_outdoor"},
          {"label": "Rarely switch focus", "value": "rarely_switch"},
        ],
      },
      {
        "id": "typical_environment",
        "step": 5,
        "question": "What best describes your typical environment?",
        "type": "single_choice",
        "options": [
          {
            "label": "Air-conditioned indoor space",
            "value": "air_conditioned_indoor",
          },
          {
            "label": "Bright or dim artificial lighting",
            "value": "bright_dim_artificial",
          },
          {
            "label": "Strong reflections or glare",
            "value": "strong_reflections_glare",
          },
          {
            "label": "High contrast lighting",
            "value": "high_contrast_lighting",
          },
          {
            "label": "Hot, dusty or harsh outdoor conditions",
            "value": "hot_dusty_harsh_outdoor",
          },
        ],
      },
    ],
  };
}
