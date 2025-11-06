//
//  ChatView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 04/11/25.
//

import SwiftUI

// MARK: - 3. Componente de Burbuja de Chat
struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            // Alineación a la derecha para el usuario actual
            if message.isCurrentUser {
                Spacer()
            }
            
            Text(message.text)
                .padding(10)
                // Color azul para el usuario actual, gris claro para el otro
                .background(message.isCurrentUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(message.isCurrentUser ? .white : .primary)
                .cornerRadius(15)
            
            // Alineación a la izquierda para otros usuarios
            if !message.isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

// MARK: - 4. Vista de Chat (ChatView)
struct ChatView: View {
    
    // ⭐️ CAMBIO AQUÍ: La vista ahora requiere un objeto User para ser inicializada.
    let chatUser: User
    
    // Estado para el texto que el usuario está escribiendo
    @State private var messageText: String = ""
    
    // Estado para la lista de mensajes
    @State private var messages: [Message] = []
    
    // Para hacer scroll al último mensaje
    @State private var scrollProxy: ScrollViewProxy?
    
    // Inicializa la vista y genera un mock de mensajes basado en la usuaria
    init(chatUser: User) {
        self.chatUser = chatUser
        // Genera mensajes de prueba específicos para el contexto
        _messages = State(initialValue: [
            Message(text: "¡Hola! Vi que también vas a \(chatUser.destination) a las \(chatUser.time). ¿Quieres ir juntas?", isCurrentUser: false),
            Message(text: "¡Claro! Me parece genial. ¿Cómo nos encontramos?", isCurrentUser: true),
            Message(text: "Podríamos vernos cerca de la entrada principal, al lado de la bandera gigante.", isCurrentUser: false),
            Message(text: "Perfecto. ¡Nos vemos allí!", isCurrentUser: true)
        ])
    }
    
    // Función para simular el envío de un mensaje
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(text: messageText, isCurrentUser: true)
        messages.append(newMessage)
        
        // Limpiar el campo de texto después de enviar
        messageText = ""
        
        // Desplazarse al último mensaje
        if let proxy = scrollProxy {
            // Se usa un pequeño retraso para permitir que la vista se actualice
            DispatchQueue.main.async {
                proxy.scrollTo(messages.last?.id, anchor: .bottom)
            }
        }
        
        print("Mensaje enviado a \(chatUser.name): \(newMessage.text)")
    }
    
    var body: some View {
        VStack {
            
            // ScrollView para la lista de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id) // Agrega un ID para el desplazamiento
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemBackground))
                .onAppear {
                    // Guarda la referencia del proxy al aparecer
                    scrollProxy = proxy
                    // Desplázate al último mensaje al cargar
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            
            // Separador visual
            Divider()
            
            // Área de composición de mensaje
            HStack {
                TextField("Escribe un mensaje...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 44)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(.systemGray6).ignoresSafeArea(.keyboard, edges: .bottom))
        }
        // ⭐️ CAMBIO AQUÍ: Título dinámico
        .navigationTitle(chatUser.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Vista Previa
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Pasa una usuaria de prueba
            ChatView(chatUser: communityMembers[0])
        }
    }
}
