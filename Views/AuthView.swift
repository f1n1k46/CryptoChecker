import SwiftUI

struct AuthenticationView: View {
    @Environment(\.authService) var authService
    @Binding var isPresented: Bool
    @State private var loginName = String()
    @State private var password = String()
    @State private var alert = AlertStruct()
    
    var body: some View {
        VStack {
            Text("Authentication")
                .font(.largeTitle)
                .padding()
            
            TextField("Username", text: $loginName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Button("Login") {
                    if loginName.isEmpty || password.isEmpty {
                        alert.messageAlert = "One of the field is empty :("
                        alert.showingAlert = true
                        return
                    }
                    if authService.readFromKeychain(account: loginName) != password {
                        alert.messageAlert = "Wrong password or login name"
                        alert.showingAlert = true
                        return
                    }
                    Settings.isLoggedIn = true
                    Settings.userName = loginName
                }
                .padding()
                .buttonStyle(.bordered)
                .alert(alert.messageAlert, isPresented: $alert.showingAlert) {
                    Button("OK", role: .cancel) {
                        alert.showingAlert = false
                    }
                }
                
                Button("Register") {
                    if loginName.isEmpty || password.isEmpty {
                        alert.messageAlert = "One of the field is empty :("
                        alert.imageAlert = Image(systemName: "x.circle")
                        alert.showingAlert = true
                        return
                    }
                    if !authService.saveToKeychain(account: loginName, token: password) {
                        alert.messageAlert = "Wrong password or login name"
                        alert.showingAlert = true
                        return
                    }
                    Settings.isLoggedIn = true
                    Settings.userName = loginName
                }
                .padding()
                .alert(alert.messageAlert, isPresented: $alert.showingAlert) {
                    Button("OK", role: .cancel) {
                        alert.showingAlert = false
                    }
                }
            }
            
            Button("Cancel") {
                isPresented = false
            }
            .padding()
        }
    }
}
