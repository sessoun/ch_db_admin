import 'package:googleapis/forms/v1.dart' as gapi;

Map<String, dynamic> requestFormJson = {
  "requests": [
    {
      "createItem": {
        "item": {
          "title": "Full Name",
          "questionItem": {
            "required": true,
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Location",
          "questionItem": {
            "required": true,
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Contact",
          "questionItem": {
            "required": true,
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Marriage Status",
          "questionItem": {
            "question": {
              "choiceQuestion": {
                "type": "DROP_DOWN",
                "options": [
                  {"value": "Single"},
                  {"value": "Married"},
                  {"value": "Divorced"},
                  {"value": "Widowed"},
                  {"value": "Separated"}
                ]
              }
            }
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Spouse Name (If Married)",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Children (Comma Separated)",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Relative Contact",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Profile Picture (Google Drive Link). After uploading, click 'Share' in Google Drive and set visibility to 'Anyone with the link'",
          "questionItem": {
            "required": true,
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title":
              "Additional Image (Google Drive Link). After uploading, click 'Share' in Google Drive and set visibility to 'Anyone with the link'",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Date of Birth (YYYY-MM-DD)",
          "questionItem": {
            "required": true,
            "question": {"textQuestion": {}}
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Group Affiliations (Comma Separated)",
          "questionItem": {
            "question": {
              "choiceQuestion": {
                "type": "RADIO",
                "options": [
                  {"value": "Youth Ministry"},
                  {"value": "Men Ministry"},
                  {"value": "Women Ministry"},
                  {"value": "Children Ministry"},
                ]
              }
            }
          }
        }
      }
    },
    {
      "createItem": {
        "item": {
          "title": "Role in Church",
          "questionItem": {
            "question": {
              "choiceQuestion": {
                "type": "RADIO",
                "options": [
                  {"value": "Member"},
                  {"value": "Leader"},
                  {"value": "Pastor"},
                  {"value": "Elder"},
                  {"value": "Deacon"},
                  {"value": "Usher"},
                  {"value": "Choir"}
                ]
              }
            }
          }
        }
      }
    }
  ]
};

// Define the questions to add
List<gapi.Request> reqObj() {
  List<gapi.Request> requests = [];

  for (var request in requestFormJson['requests'] ?? []) {
    var createItem = request['createItem'];
    var item = createItem?['item'];

    if (item == null) continue; // Skip if item is null

    // Extract question type
    var questionItem = item['questionItem'];
    var question = questionItem?['question'];

    if (question == null) continue; // Skip if question is null

    gapi.Item gapiItem = gapi.Item(title: item['title']);

    if (question.containsKey('textQuestion')) {
      gapiItem.questionItem = gapi.QuestionItem(
        question: gapi.Question(
            required: questionItem['required'] ?? false,
            textQuestion: gapi.TextQuestion()),
      );
    } else if (question.containsKey('choiceQuestion')) {
      var choiceQuestion = question['choiceQuestion'];
      gapiItem.questionItem = gapi.QuestionItem(
        question: gapi.Question(
          choiceQuestion: gapi.ChoiceQuestion(
            type: choiceQuestion['type'] ??
                "RADIO", // Default to RADIO if missing
            options: (choiceQuestion['options'] as List?)
                    ?.map((option) => gapi.Option(value: option['value']))
                    .toList() ??
                [],
          ),
        ),
      );
    } else if (question.containsKey('fileUploadQuestion')) {
      gapiItem.questionItem = gapi.QuestionItem(
        question: gapi.Question(fileUploadQuestion: gapi.FileUploadQuestion()),
      );
    }

    // Append to requests list with index location
    requests.add(gapi.Request(
      createItem: gapi.CreateItemRequest(
        item: gapiItem,
        location: gapi.Location(index: requests.length),
      ),
    ));
  }

  return requests;
}
