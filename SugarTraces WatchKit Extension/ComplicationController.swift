//
//  ComplicationController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 14/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import ClockKit
import WatchKit

//complication controller

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let defaults = UserDefaults.standard
    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])

    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        loadLoggedData()
        if complication.family == .modularLarge {
            let headerTextProvider = CLKSimpleTextProvider(text: "Last Reading")
            var body1TextProvider = CLKSimpleTextProvider(text: "")
            var body2TextProvider = CLKSimpleTextProvider(text: "")

            if loggedReadings.isEmpty {
                body1TextProvider = CLKSimpleTextProvider(text: "No last reading")
                body2TextProvider = CLKSimpleTextProvider(text: "No last date")
            } else {
                body1TextProvider = CLKSimpleTextProvider(text: "\(loggedReadings[0]) mg/DL")
                body2TextProvider = CLKSimpleTextProvider(text: "\(loggedDates[0])")
            }

            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = headerTextProvider
            template.body1TextProvider = body1TextProvider
            template.body2TextProvider = body2TextProvider
            
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template)
            handler(timelineEntry)

        } else {
            handler(nil)
        }
    }
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Update hourly
    //https://stackoverflow.com/questions/37819483/watchos-show-realtime-departure-data-on-complication
        handler(NSDate(timeIntervalSinceNow: 0.01))
    }
    
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let currentDate = Date()
        handler(currentDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        var currentDate = Date()
        currentDate.addingTimeInterval(1)
        handler(currentDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        loadLoggedData()

        let headerTextProvider = CLKSimpleTextProvider(text: "Last Reading")
        var body1TextProvider = CLKSimpleTextProvider(text: "")
        var body2TextProvider = CLKSimpleTextProvider(text: "")

        if loggedReadings.isEmpty {
            body1TextProvider = CLKSimpleTextProvider(text: "No last reading")
            body2TextProvider = CLKSimpleTextProvider(text: "No last date")
        } else {
            body1TextProvider = CLKSimpleTextProvider(text: "\(loggedReadings[0]) mg/DL")
            body2TextProvider = CLKSimpleTextProvider(text: "\(loggedDates[0])")
        }

        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = headerTextProvider
        template.body1TextProvider = body1TextProvider
        template.body2TextProvider = body2TextProvider


        handler(template)
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        loadLoggedData()
        
        let headerTextProvider = CLKSimpleTextProvider(text: "Last Reading")
        var body1TextProvider = CLKSimpleTextProvider(text: "")
        var body2TextProvider = CLKSimpleTextProvider(text: "")

        if loggedReadings.isEmpty {
            body1TextProvider = CLKSimpleTextProvider(text: "No last reading")
            body2TextProvider = CLKSimpleTextProvider(text: "No last date")
        } else {
            body1TextProvider = CLKSimpleTextProvider(text: "\(loggedReadings[0])")
            body2TextProvider = CLKSimpleTextProvider(text: "\(loggedDates[0])")
        }


        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = headerTextProvider
        template.body1TextProvider = body1TextProvider
        template.body2TextProvider = body2TextProvider


        handler(template)

        
    }
    
    func templateForComp() -> CLKComplicationTemplate {
        loadLoggedData()
        let headerTextProvider = CLKSimpleTextProvider(text: "Last Reading")
        var body1TextProvider = CLKSimpleTextProvider(text: "")
        var body2TextProvider = CLKSimpleTextProvider(text: "")

        if loggedReadings.isEmpty {
            body1TextProvider = CLKSimpleTextProvider(text: "No last reading")
            body2TextProvider = CLKSimpleTextProvider(text: "No last date")
        } else {
            body1TextProvider = CLKSimpleTextProvider(text: "\(loggedReadings[0])")
            body2TextProvider = CLKSimpleTextProvider(text: "\(loggedDates[0])")
        }

        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = headerTextProvider
        template.body1TextProvider = body1TextProvider
        template.body2TextProvider = body2TextProvider
        
        return template
    }
    
    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
}


/*
 $(PRODUCT_MODULE_NAME).
 
 */
