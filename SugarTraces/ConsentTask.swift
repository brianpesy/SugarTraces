//
//  ConsentTask.swift
//  SugarTraces
//
//  Created by Brian Sy on 30/01/2020.
//  Copyright © 2020 Brian Sy. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {

    var ctr = 0

    let Document = ORKConsentDocument()
    Document.title = "SugarTraces Consent"
    
    //section types
    let sectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
//        .dataUse,
//        .timeCommitment,
//        .studySurvey,
//        .studyTasks,
//        .withdrawing
    ]
    
    //content of the different sections
//    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
//        let consentSection = ORKConsentSection(type: contentSectionType)
//        consentSection.summary = "Complete the study"
//        consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
//        return consentSection
//    }
    
//    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
//        let consentSection = ORKConsentSection(type: contentSectionType)
//        consentSection.summary = "Complete the study"
//        consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
//        return consentSection
//    }
    
    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        
        if ctr < sectionTypes.count {
            
            if ctr == 0 { //Welcome
                consentSection.summary = "SugarTraces wishes to improve its system as a whole to help further influence other users to live healthier lifestyles."
                consentSection.content = "By participating in this study, it will help improve the overall experience of the application through further research and feedback. This will help the application grow and develop to become more effective in its goals to help users with prediabetes and diabetes to live a healthier lifestyle by maintaining healthy blood glucose levels."
            }
                
            else if ctr == 1 { //Data Gathering
                consentSection.summary = "SugarTraces will be asking a series of questions regarding your activity on the application and current health statuses."
                consentSection.content = "The data gathered in this survey will range from questions regarding your own activity within the application itself, your behavior outside of the application, and its effects on you. This is so SugarTraces has a benchmark whether the implemented features in the application are working towards our goal or not."
            }
                
            else if ctr == 2 { //Privacy
                consentSection.summary = "No data sent over will include any personally identifiable information."
                consentSection.content = "We respect your privacy that is why we will never ask for any personally identifiable information. As such, any information that is sent over to us cannot be traced back to you."
            }
            
            ctr = ctr + 1
        }
        return consentSection
    }
    
    
    //signature
    Document.sections = consentSections
    Document.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
    
    var steps = [ORKStep]()
     
    //Visual Consent
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: Document)
    steps += [visualConsentStep]
     
    //Signature (shows after saying "agree")
    let signature = Document.signatures!.first! as ORKConsentSignature
    let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature, in: Document)
    reviewConsentStep.text = "Please review the consent"
    reviewConsentStep.reasonForConsent = "By agreeing to this, I hereby claim to participate in this research study."
     
    steps += [reviewConsentStep]
     
    //Completion
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Welcome"
    completionStep.text = "Thank you for helping SugarTraces!"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
