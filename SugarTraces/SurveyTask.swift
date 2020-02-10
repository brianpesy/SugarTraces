//
//  SurveyTask.swift
//  SugarTraces
//
//  Created by Brian Sy on 30/01/2020.
//  Copyright © 2020 Brian Sy. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Introduction
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Test Survey"
    instructionStep.text = "Answer three questions to complete the survey."
    steps += [instructionStep]

    //Text Input Question
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "NameStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    steps += [nameQuestionStep]
    
    //multiple choice. Question 1. Change all the "question1steps" to others
    let question1 = "The application can help influence users to maintain blood glucose levels."
    let textChoices = [
      ORKTextChoice(text: "1: Strongly Disagree", value: 1 as NSNumber),
      ORKTextChoice(text: "2", value: 2 as NSNumber),
      ORKTextChoice(text: "3", value: 3 as NSNumber),
      ORKTextChoice(text: "4", value: 4 as NSNumber),
      ORKTextChoice(text: "5: Strongly Agree", value: 5 as NSNumber)
    ]
    let question1AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question1Step = ORKQuestionStep(identifier: "Question1Step", title: question1, answer: question1AnswerFormat)
    question1Step.isOptional = false
    steps += [question1Step]
    
    //multiple choice. Question 2.
    let question2 = "The application helps users to remind themselves to maintain a healthy lifestyle through the motivational feedback messages."
    let question2AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question2Step = ORKQuestionStep(identifier: "Question2Step", title: question2, answer: question2AnswerFormat)
    question2Step.isOptional = false
    steps += [question2Step]
    
    //multiple choice. Question 3.
    let question3 = "The feedback phrases (i.e. the phrases provided after entering an input) give me positive energy. "
    let question3AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question3Step = ORKQuestionStep(identifier: "Question3Step", title: question3, answer: question3AnswerFormat)
    question3Step.isOptional = false
    steps += [question3Step]
    
    //multiple choice. Question 4.
    let question4 = "The feedback phrases made me want to use the application more."
    let question4AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question4Step = ORKQuestionStep(identifier: "Question4Step", title: question4, answer: question4AnswerFormat)
    question4Step.isOptional = false
    steps += [question4Step]
    
    //multiple choice. Question 5.
    let question5 = "The feedback phrases help me stay motivated."
    let question5AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question5Step = ORKQuestionStep(identifier: "Question5Step", title: question5, answer: question5AnswerFormat)
    question5Step.isOptional = false
    steps += [question5Step]
    
    //multiple choice. Question 6.
    let question6 = "The application helped me want to maintain blood glucose levels consistently."
    let question6AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question6Step = ORKQuestionStep(identifier: "Question6Step", title: question6, answer: question6AnswerFormat)
    question6Step.isOptional = false
    steps += [question6Step]
    
    //multiple choice. Question 7.
    let question7 = "The application helped change my lifestyle for the better."
    let question7AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question7Step = ORKQuestionStep(identifier: "Question7Step", title: question7, answer: question7AnswerFormat)
    question7Step.isOptional = false
    steps += [question7Step]
    
    //multiple choice. Question 8.
    let question8 = "I can reach my personal goals using this application."
    let question8AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question8Step = ORKQuestionStep(identifier: "Question8Step", title: question8, answer: question8AnswerFormat)
    question8Step.isOptional = false
    steps += [question8Step]
    
    //multiple choice. Question 9.
    let question9 = "I will use the application regularly."
    let question9AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question9Step = ORKQuestionStep(identifier: "Question9Step", title: question9, answer: question9AnswerFormat)
    question9Step.isOptional = false
    steps += [question9Step]
    
    //multiple choice. Question 10.
    let question10 = "I thought that the application was easy to use."
    let question10AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question10Step = ORKQuestionStep(identifier: "Question10Step", title: question10, answer: question10AnswerFormat)
    question10Step.isOptional = false
    steps += [question10Step]
    
    //multiple choice. Question 11.
    let question11 = "I think that I would need the support of a technical person to be able to use the application."
    let question11AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question11Step = ORKQuestionStep(identifier: "Question11Step", title: question11, answer: question11AnswerFormat)
    question11Step.isOptional = false
    steps += [question11Step]
    
    //multiple choice. Question 12.
    let question12 = "I would imagine that most people would learn to use the application very quickly."
    let question12AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question12Step = ORKQuestionStep(identifier: "Question12Step", title: question12, answer: question12AnswerFormat)
    question12Step.isOptional = false
    steps += [question12Step]
    
    //multiple choice. Question 13.
    let question13 = "I found the various features in the application were well integrated."
    let question13AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question13Step = ORKQuestionStep(identifier: "Question13Step", title: question13, answer: question13AnswerFormat)
    question13Step.isOptional = false
    steps += [question13Step]
    
    //multiple choice. Question 14.
    let question14 = "I felt very confident using the application."
    let question14AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question14Step = ORKQuestionStep(identifier: "Question14Step", title: question14, answer: question14AnswerFormat)
    question14Step.isOptional = false
    steps += [question14Step]
    
    
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!"
    completionStep.text = "You have completed the survey."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
