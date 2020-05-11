export default {
  "type": "block",
  "conjunction": {
    "value": "$and",
    "text": "alle Bedingungen erfüllt",
    "context": null
  },
  "content": [
    {
      "type": "block",
      "conjunction": {
        "value": "fall",
        "text": "für das Unterdokument Fall",
        "context": "fall"
      },
      "content": [
        {
          "type": "sentence",
          "content": {
            "subject": {
              "value": "IK",
              "text": "Ik"
            },
            "predicate": {
              "value": "$eq",
              "text": "="
            },
            "object": "1"
          }
        },
        {
          "type": "sentence",
          "content": {
            "subject": {
              "value": "IK",
              "text": "Ik"
            },
            "predicate": {
              "value": "$eq",
              "text": "="
            },
            "object": "2"
          }
        }
      ]
    },
    {
      "type": "block",
      "conjunction": {
        "value": "icd",
        "text": "für mindestens einen Eintrag im Underdokument Icd",
        "context": "icd"
      },
      "content": [
        {
          "type": "sentence",
          "content": {
            "subject": {
              "value": "ICD-Kode",
              "text": "Icd kode"
            },
            "predicate": {
              "value": "$eq",
              "text": "="
            },
            "object": "3"
          }
        },
        {
          "type": "sentence",
          "content": {
            "subject": {
              "value": "IK",
              "text": "Ik"
            },
            "predicate": {
              "value": "$eq",
              "text": "="
            },
            "object": "4"
          }
        }
      ]
    }
  ]
}
