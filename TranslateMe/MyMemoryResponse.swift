//
//  MyMemoryResponse.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//


import Foundation

struct MyMemoryResponse: Codable {
    struct ResponseData: Codable {
        let translatedText: String
    }
    let responseData: ResponseData
}

class TranslationService {
    // Translates text from one language to another using MyMemory API
    func translate(text: String, from source: Language, to target: Language) async throws -> String {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ""
        }

        var components = URLComponents(string: "https://api.mymemory.translated.net/get")!
        let qItem = URLQueryItem(name: "q", value: text)
        let langPairItem = URLQueryItem(name: "langpair", value: "\(source.rawValue)|\(target.rawValue)")
        components.queryItems = [qItem, langPairItem]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) == false {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
        return decoded.responseData.translatedText
    }
}
