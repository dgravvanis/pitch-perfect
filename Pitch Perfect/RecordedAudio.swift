//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Dimitrios Gravvanis on 5/4/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

// Import the frameworks
import Foundation

// Model to store audio
class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    // Initializers
    init(filePathUrl:NSURL, title:String) {
        
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
