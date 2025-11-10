//
//  ChatView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 04/11/25.
//

import SwiftUI

// MARK: - Componente de Burbuja de Chat
struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        if message.role == .alert {
            VStack(alignment: .trailing, spacing: 5) {
                Text(.init(message.text))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                
                if let mapURL = message.url {
                    Link(destination: mapURL) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Ubicación")
                                .underline()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 4)
                    }
                }
                
                Text("Enviado: \(Date(), style: .time)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(15)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
        } else if message.role == .checkin {
            
            VStack(alignment: .trailing, spacing: 5) {
                
                Text(message.text)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                    
                Text("Enviado: \(Date(), style: .time)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(Color("Verde"))
            .foregroundColor(.white)
            .cornerRadius(15)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
        } else {
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }
                
                Text(message.text)
                    .padding(10)
                    .background(message.isCurrentUser ? Color.purple : Color(.systemGray5))
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .cornerRadius(15)
                
                if !message.isCurrentUser {
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
    }
}

// MARK: - Vista de Chat 
struct ChatView: View {
    let chatUser: User
    
    @State private var messageText: String = ""
    
    @State private var messages: [Message] = []
    
    @State private var scrollProxy: ScrollViewProxy?
    
    @EnvironmentObject var locationManager: LocationManager
    
    // Mock de mensajes basado en la usuaria
    init(chatUser: User) {
        self.chatUser = chatUser
        // Mensajes de prueba
        _messages = State(initialValue: [
            Message(text: "¡Hola! Vi que también vas a \(chatUser.destination) a las \(chatUser.time). ¿Quieres ir juntas?", isCurrentUser: false, role: .user, url: nil),
            Message(text: "¡Claro! Me parece genial. ¿Cómo nos encontramos?", isCurrentUser: true, role: .user,  url: nil),
            Message(text: "Podríamos vernos cerca de la entrada principal, al lado de la bandera gigante.", isCurrentUser: false, role: .user,  url: nil),
            Message(text: "Perfecto. ¡Nos vemos allí!", isCurrentUser: true, role: .user,  url: nil)
        ])
    }
    
    // Función para simular el envío de un mensaje
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(text: messageText, isCurrentUser: true, role: .user,  url: nil)
        messages.append(newMessage)
        
        messageText = ""
        
        if let proxy = scrollProxy {
            DispatchQueue.main.async {
                proxy.scrollTo(messages.last?.id, anchor: .bottom)
            }
        }
        
    }
    

    func sendEmergencyAlert() {
        
        var locationText = "Ubicación no disponible."
        var mapURL: URL? = nil
        
        if let location = locationManager.location {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            let formattedLat = String(format: "%.6f", lat)
            let formattedLon = String(format: "%.6f", lon)
            
            let mapLinkString = "http://maps.apple.com/?q=\(formattedLat),\(formattedLon)"
            mapURL = URL(string: mapLinkString)
            locationText = "Coordenadas: \(formattedLat), \(formattedLon)"
        } else {
        }
        
        let alertContent: String
        if mapURL != nil {
            alertContent = "ALERTA DE EMERGENCIA ACTIVADA. Necesito ayuda."
        } else {
            alertContent = "ALERTA DE EMERGENCIA ACTIVADA. Necesito ayuda. (\(locationText))"
        }
        
        let emergencyMessage = Message(text: alertContent, isCurrentUser: true, role: .alert, url: mapURL)
        messages.append(emergencyMessage)
        
    }
    
    // Mensaje de confirmación de seguridad
    func sendCheckinMessage() {
        
        let checkinContent = "CHECK-IN: Ya llegué. Todo está bien."
        
        let checkinMessage = Message(
            text: checkinContent,
            isCurrentUser: true,
            role: .checkin,
            url: nil
        )
        
        messages.append(checkinMessage)
        
        if let proxy = scrollProxy {
            DispatchQueue.main.async {
                proxy.scrollTo(messages.last?.id, anchor: .bottom)
            }
        }
    }

    
    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemBackground))
                .onAppear {
                    scrollProxy = proxy
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            
            Divider()
            
            // Composición de mensaje
            HStack {
                TextField("Escribe un mensaje...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 44)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(.purple)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(.systemGray6).ignoresSafeArea(.keyboard, edges: .bottom))
            
        }
        
        .navigationTitle(chatUser.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: sendCheckinMessage) {
                    Label("Check-in", systemImage: "hand.thumbsup.fill") 
                        .font(.title3)
                }
                .tint(.green)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: sendEmergencyAlert) {
                    Label("Alerta", systemImage: "exclamationmark.triangle.fill")
                        .font(.title2)
                }
                .tint(.red)
            }
        }
    }
}

// MARK: - Vista Previa
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chatUser: communityMembers[0])
        }
    }
}
