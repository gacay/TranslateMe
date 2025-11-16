import SwiftUI

struct TranslationHomeView: View {
    @StateObject var viewModel: TranslationViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false   // 👈 remember user choice

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Input text
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter text to translate")
                            .font(.headline)
                        TextField("Type here...", text: $viewModel.inputText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3, reservesSpace: true)
                    }

                    // Language pickers
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Picker("From", selection: $viewModel.sourceLanguage) {
                                ForEach(Language.allCases) { lang in
                                    Text(lang.displayName).tag(lang)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("To")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Picker("To", selection: $viewModel.targetLanguage) {
                                ForEach(Language.allCases) { lang in
                                    Text(lang.displayName).tag(lang)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    // Translate button
                    Button {
                        Task {
                            await viewModel.translate()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Text("Translate")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        viewModel.inputText
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty || viewModel.isLoading
                    )

                    // Output
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Translation")
                            .font(.headline)
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                )

                            Text(
                                viewModel.outputText.isEmpty
                                ? "Translated text will appear here..."
                                : viewModel.outputText
                            )
                            .padding(8)
                            .foregroundStyle(
                                viewModel.outputText.isEmpty ? .secondary : .primary
                            )
                        }
                        .frame(minHeight: 80)
                    }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    // History header
                    HStack {
                        Text("History")
                            .font(.title3)
                            .bold()
                        Spacer()
                        if !viewModel.translations.isEmpty {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.clearHistory()
                                }
                            } label: {
                                Label("Clear", systemImage: "trash")
                                    .font(.subheadline)
                            }
                        }
                    }

                    // History list
                    if viewModel.translations.isEmpty {
                        Text("No translations yet. Try translating something!")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.translations) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("\(item.sourceLangCode.uppercased()) → \(item.targetLangCode.uppercased())")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text(item.createdAt, style: .time)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(item.originalText)
                                        .font(.subheadline)
                                    Text(item.translatedText)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("TranslateMe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)   // 👈 force dark/light
    }
}
