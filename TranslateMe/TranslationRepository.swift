//
//  TranslationRepository.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//


import Foundation
import FirebaseFirestore

class TranslationRepository {
    private let db = Firestore.firestore()
    private let collectionName = "translations"

    // Save a translation
    func save(_ translation: Translation) async throws {
        try db
            .collection(collectionName)
            .document(translation.id)
            .setData(from: translation)
    }

    // Fetch all translations ordered by date (newest first)
    func fetchAll() async throws -> [Translation] {
        let snapshot = try await db
            .collection(collectionName)
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { document in
            try? document.data(as: Translation.self)
        }
    }

    // Delete all translations
    func deleteAll() async throws {
        let snapshot = try await db.collection(collectionName).getDocuments()
        let batch = db.batch()

        for doc in snapshot.documents {
            batch.deleteDocument(doc.reference)
        }

        try await batch.commit()
    }
}
