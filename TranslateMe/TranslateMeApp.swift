//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Victoria Huynh on 11/14/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TranslateMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TranslationHomeView(
                    viewModel: TranslationViewModel(
                        service: TranslationService(),
                        repository: TranslationRepository()
                    )
                )
            }
        }
    }
}
