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
    let question1 = "What is your quest?"
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
    let question2 = "Question 2?"
    let question2AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let question2Step = ORKQuestionStep(identifier: "Question2Step", title: question2, answer: question2AnswerFormat)
    question2Step.isOptional = false
    steps += [question2Step]
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
