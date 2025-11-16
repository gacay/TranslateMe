//
//  Language.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//


import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case italian = "it"
    case french  = "fr"
    case german  = "de"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .italian: return "Italian"
        case .french:  return "French"
        case .german:  return "German"
        }
    }
}
