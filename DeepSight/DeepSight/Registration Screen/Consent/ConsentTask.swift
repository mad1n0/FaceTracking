//
//  ConsentTask.swift
//  DeepSight
//
//  Created by Kleomenis Katevas on 4/12/20.
//

import Foundation
import ResearchKit
import SwiftyJSON

public var ConsentTask: ORKOrderedTask {
    
    let document = ORKConsentDocument()
    document.title = "Participant Information Sheet"
    document.signaturePageTitle = "I Consent"
    
    // Load sections
    document.sections = loadSections(fromResource: "visual_consent")
    document.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
    
    var steps = [ORKStep]()
    
    // Visual Consent
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: document)
    steps += [visualConsentStep]
    
    // Load actual content (non visual) in html
    if let path = Bundle.main.path(forResource: "consent", ofType: "html") {
        document.htmlReviewContent = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
    
    // Signature
    let signature = document.signatures!.first! as ORKConsentSignature
    let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature, in: document)
    reviewConsentStep.text = "Consent to join the Research Study."
    reviewConsentStep.reasonForConsent = "By agreeing you confirm that you read the consent form and that you wish to take part in this research study."
    //reviewConsentStep.requiresScrollToBottom = true
    steps += [reviewConsentStep]
    
//    // Completion
//    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
//    completionStep.title = "DoshWell Study"
//    completionStep.text = "Thank you for joining our study."
//    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}

func loadSections(fromResource resource:String) -> Array<ORKConsentSection> {
    
    let json = loadJson(fromResource: resource)
    var sections = [ORKConsentSection]()
    
    for (_, subJson):(String, JSON) in json {
        sections += [createSection(withJson: subJson)]
    }
    
    return sections
}

func loadJson(fromResource resource:String) -> JSON {
    
    if let path = Bundle.main.path(forResource: resource, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let json = try JSON(data: data)
            return json
            
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            abort()
        }
    } else {
        print("Invalid filename/path.")
        abort()
    }
}

func createSection(withJson json:JSON) -> ORKConsentSection {
    
    let type = json["type"].string
        
    let consentSection = ORKConsentSection(type: consentType(fromText: type))
    
    if let title = json["title"].string {
        consentSection.title = title
    }
    
    if let formalTitle = json["formalTitle"].string {
        consentSection.formalTitle = formalTitle
    }
    
    if let summary = json["summary"].string {
        consentSection.summary = summary
    }
    
    if let content = json["content"].string {
        consentSection.content = content
    }
    
    if let htmlContentResource = json["htmlContentResource"].string {
        if let path = Bundle.main.path(forResource: htmlContentResource, ofType: "html") {
            consentSection.htmlContent = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        }
    }
    else if let htmlContent = json["htmlContent"].string {
        consentSection.htmlContent = htmlContent
    }
    
    if let omitFromDocument = json["omitFromDocument"].bool {
        consentSection.omitFromDocument = omitFromDocument
    }
    
    if let customImage = json["customImage"].string {
        consentSection.customImage = UIImage.init(named: customImage)
    }
    
    if let customLearnMoreButtonTitle = json["customLearnMoreButtonTitle"].string {
        consentSection.customLearnMoreButtonTitle = customLearnMoreButtonTitle
    }
    
    return consentSection
}


func consentType(fromText text:String?) -> ORKConsentSectionType {
    
    switch text {
        
    case nil:
        return .custom
        
    case "Overview":
        return .overview
        
    case "Data Gathering":
        return .dataGathering
        
    case "Privacy":
        return .privacy
        
    case "Data Use":
        return .dataUse
        
    case "Time Commitment":
        return .timeCommitment
        
    case "Study Survey":
        return .studySurvey
    
    case "Study Tasks":
        return .studyTasks
        
    case "Withdrawing":
        return .withdrawing
        
    case "Custom":
        return .custom
        
    case "Only In Document":
        return .onlyInDocument
        
    default:
        print("Unknown ORKConsentSectionType for text: \(text!)")
        abort()
    }
}
