//
//  TranslationViewModel.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//


import Foundation

@MainActor
class TranslationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var outputText: String = ""
    @Published var sourceLanguage: Language = .english
    @Published var targetLanguage: Language = .spanish
    
    @Published var translations: [Translation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: TranslationService
    private let repository: TranslationRepository

    init(service: TranslationService, repository: TranslationRepository) {
        self.service = service
        self.repository = repository
        
        Task {
            await loadHistory()
        }
    }

    func translate() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let translated = try await service.translate(
                text: inputText,
                from: sourceLanguage,
                to: targetLanguage
            )
            outputText = translated

            let translation = Translation(
                originalText: inputText,
                translatedText: translated,
                sourceLangCode: sourceLanguage.rawValue,
                targetLangCode: targetLanguage.rawValue,
                createdAt: Date()
            )

            try await repository.save(translation)
            await loadHistory()
        } catch {
            errorMessage = "Translation failed: \(error.localizedDescription)"
        }
    }

    func loadHistory() async {
        do {
            let items = try await repository.fetchAll()
            self.translations = items
        } catch {
            self.errorMessage = "Failed to load history: \(error.localizedDescription)"
        }
    }

    func clearHistory() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await repository.deleteAll()
            self.translations = []
        } catch {
            self.errorMessage = "Failed to clear history: \(error.localizedDescription)"
        }
    }
}
