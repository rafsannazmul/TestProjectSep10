//
//  Constants.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation

enum AppURL
{
    case demo
    case live
    var instance :String {
        switch  self
        {
        case .live:
            return "⌘ Add live server url here"
        case .demo :
            return "⌘ Add demo server url here"
        }
    }
}

let k_WebServerUrl = "⌘ Add web server URL here"
