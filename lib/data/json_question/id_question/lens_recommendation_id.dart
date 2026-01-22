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
        "question": "Apakah Anda memiliki minus (jarak jauh) pada salah satu mata?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Tidak yakin"},
          {"label": "0.00_to_-2.00", "value": "0.00 hingga -2.00"},
          {"label": "-2.00_to_-4.00", "value": "-2.00 hingga -4.00"},
          {"label": "-4.00_to_-6.00", "value": "-4.00 hingga -6.00"},
          {"label": "below_-6.00", "value": "Di bawah -6.00"},
        ],
      },
      {
        "id": "plus_power",
        "step": 4,
        "question":
            "Apakah Anda memiliki plus (bantuan membaca) pada salah satu mata?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Tidak yakin"},
          {"label": "0.00", "value": "0.00"},
          {"label": "+0.50_to_+1.00", "value": "+0.50 hingga +1.00"},
          {"label": "+1.00_to_+2.00", "value": "+1.00 hingga +2.00"},
          {"label": "above_+2.00", "value": "Di atas +2.00"},
        ],
      },
      {
        "id": "astigmatism",
        "step": 5,
        "question": "Apakah Anda memiliki astigmatisme (silinder)?",
        "type": "single_choice",
        "options": [
          {"label": "not_sure", "value": "Tidak yakin"},
          {"label": "0.00", "value": "0.00"},
          {"label": "−0.25_to_−1.00", "value": "−0.25 hingga −1.00"},
          {"label": "−1.00_to_−2.00", "value": "−1.00 hingga −2.00"},
          {"label": "Below_−2.00", "value": "Di bawah −2.00"},
        ],
      },
      {
        "id": "wearing_purpose",
        "step": 6,
        "question": "Di mana Anda paling sering menggunakan kacamata?",
        "type": "single_choice",
        "options": [
          {"label": "mostly_indoor", "value": "Sebagian besar di luar ruangan"},
          {"label": "mostly_indoor", "value": "Sebagian besar di dalam ruangan"},
          {"label": "balance", "value": "Seimbang"},
          {"label": "screen_focused", "value": "Fokus pada layar"},
        ],
      },
      {
        "id": "important_distance",
        "step": 7,
        "question": "Jarak mana yang paling penting bagi Anda untuk terlihat jelas?",
        "type": "single_choice",
        "options": [
          {
            "label": "near_distance_clarity",
            "value": "Kejelasan jarak jauh (misalnya mengemudi, aktivitas luar ruangan)",
          },
          {
            "label": "intermediate_distance_clarity",
            "value": "Fokus jarak menengah",
          },
          {
            "label": "near_distance_clarity",
            "value": "Kejelasan jarak dekat (misalnya membaca, penggunaan layar)",
          },
          {
            "label": "all_distance_clarity",
            "value":
                "Seimbang: semua jarak sama pentingnya (tanpa kompromi)",
          },
        ],
      },
      {
        "id": "digital_eye_fatigue",
        "step": 8,
        "question":
            "Seberapa sering Anda mengalami kelelahan mata saat menggunakan perangkat digital dalam waktu lama (ponsel, komputer, tablet)?",
        "type": "single_choice",
        "options": [
          {"label": "never", "value": "Tidak pernah"},
          {"label": "sometimes", "value": "Kadang-kadang"},
          {"label": "often", "value": "Sering"},
          {"label": "almost_always", "value": "Hampir selalu"},
        ],
      },
      {
        "id": "uv_protection_importance",
        "step": 9,
        "question":
            "Seberapa penting perlindungan dari sinar matahari dan sinar UV bagi Anda?",
        "type": "single_choice",
        "options": [
          {"label": "not_important", "value": "Tidak penting"},
          {"label": "slightly_important", "value": "Sedikit penting"},
          {"label": "important", "value": "Penting"},
          {"label": "very_important", "value": "Sangat penting"},
          {"label": "extremely_important", "value": "Sangat amat penting"},
        ],
      },
      {
        "id": "light_sensitivity",
        "step": 10,
        "question":
            "Seberapa sensitif mata Anda terhadap cahaya terang atau silau (misalnya lampu kendaraan atau pencahayaan kuat)?",
        "type": "single_choice",
        "options": [
          {"label": "never", "value": "Tidak pernah"},
          {"label": "sometimes", "value": "Kadang-kadang"},
          {"label": "often", "value": "Sering"},
          {"label": "almost_always", "value": "Hampir selalu"},
        ],
      },
      {
        "id": "impact_resistance_importance",
        "step": 11,
        "question":
            "Seberapa penting lensa yang kuat dan tahan benturan bagi Anda (untuk olahraga, anak-anak, atau aktivitas aktif)?",
        "type": "single_choice",
        "options": [
          {"label": "not_needed", "value": "Tidak dibutuhkan"},
          {"label": "nice_to_have", "value": "Bagus jika ada"},
          {"label": "somewhat_important", "value": "Cukup penting"},
          {"label": "very_important", "value": "Sangat penting"},
          {"label": "must_have", "value": "Wajib ada"},
        ],
      },
      {
        "id": "budget_preference",
        "step": 12,
        "question": "Mana yang paling menggambarkan keinginan Anda?",
        "type": "single_choice",
        "options": [
          {"label": "most_affordable", "value": "Paling terjangkau"},
          {
            "label": "good_quality_reasonable_price",
            "value": "Kualitas bagus dengan harga wajar",
          },
          {"label": "premium_performance", "value": "Performa premium"},
        ],
      },
    ],
  };
}
