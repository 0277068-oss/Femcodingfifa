import SwiftUI

struct LanguageOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
}

let availableLanguages: [LanguageOption] = [
    LanguageOption(name: "Español", code: "es"),
    LanguageOption(name: "Inglés", code: "en"),
]

// MARK: - Traductor
struct TranslatorView: View {
    
    let accentColor = Color("Verde")
    
    @State private var textToTranslate: String = "Necesito ayuda, por favor."
    @State private var translatedText: String = "I need help, please."
    
    @State private var sourceLanguage: LanguageOption = availableLanguages[0]
    @State private var targetLanguage: LanguageOption = availableLanguages[1]
    
    
    let translations: [String: String] = [
        "Necesito ayuda, por favor.": "I need help, please.",
        "I need help, please.": "Necesito ayuda, por favor.",
        "¿Dónde está el estadio?": "Where is the stadium?",
        "Todo está bien.": "Everything is okay.",
        "Estoy aquí.": "I am here."
    ]
    
    // Invertir idiomas
    func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        
        let tempText = textToTranslate
        textToTranslate = translatedText
        translatedText = tempText
    }
    
    func performSimulatedTranslation() {
        
        if sourceLanguage.code == "es" && targetLanguage.code == "en" {
            self.translatedText = translations[self.textToTranslate] ?? "Translation not found. (Example in ES->EN: I need help, please.)"
        }
        else if sourceLanguage.code == "en" && targetLanguage.code == "es" {
            let inverseTranslations = translations.reduce(into: [String: String]()) { result, element in
                result[element.value] = element.key
            }
            self.translatedText = inverseTranslations[self.textToTranslate] ?? "Translation not found. (Example in EN->ES: Necesito ayuda, por favor.)"
        }
        else {
            self.translatedText = "Selecciona un par de idiomas soportados: ES ↔️ EN"
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            
            // MARK: - Selector de Idiomas y SWAP
            HStack {
                // Idioma de Origen
                Picker("Español", selection: $sourceLanguage) {
                    ForEach(availableLanguages, id: \.self) { lang in
                        Text(lang.name)
                            .bold()
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Botón de Swap (Invertir)
                Button(action: swapLanguages) {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(accentColor)
                }
                
                // Idioma de Destino
                Picker("Inglés", selection: $targetLanguage) {
                    ForEach(availableLanguages, id: \.self) { lang in
                        Text(lang.name)
                            .bold()
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding(.top)
            
            // MARK: - Entrada
            VStack(alignment: .leading, spacing: 10) {
                Text("\(sourceLanguage.name) (\(sourceLanguage.code.uppercased()))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $textToTranslate)
                    .frame(height: 120)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, -4)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
            
            // MARK: - Acción
            Button(action: performSimulatedTranslation) {
                HStack {
                    Image(systemName: "arrow.right.arrow.left.square.fill")
                    Text("Traducir Mensaje")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            
            // MARK: - Salida 
            VStack(alignment: .leading, spacing: 10) {
                Text("\(targetLanguage.name) (\(targetLanguage.code.uppercased())) - Traducción")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(translatedText)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Traductor")
        .navigationBarTitleDisplayMode(.inline)
    }
}
