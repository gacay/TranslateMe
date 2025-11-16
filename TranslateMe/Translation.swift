//
//  Translation.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//


import Foundation

struct Translation: Identifiable, Codable {
    var id: String = UUID().uuidString
    let originalText: String
    let translatedText: String
    let sourceLangCode: String
    let targetLangCode: String
    let createdAt: Date
}
