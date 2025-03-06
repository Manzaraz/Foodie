//
//  LoginView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 05/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        ZStack {
            Color("launchScreenBg")
                .ignoresSafeArea()
            
            VStack {
                Image("logoIcon")
                    .resizable()
                    .scaledToFit()
                    
                Group {
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        
                    SecureField("password", text: $password)
                        .submitLabel(.done)
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                
                HStack (spacing: 30) {
                    Button("Sign Up") {
                        register()
                    }
                    
                    Button("Log In") {
                        login()
                        
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.foodie)
                .font(.title)
                .padding(.top)
                
                
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    launchScreenManager.dismiss()
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
        }
    }
    
    
    
}


#Preview {
    LoginView()
        .environmentObject(LaunchScreenManager())
}


extension LoginView {
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("😡SIGNUP ERROR: \(error.localizedDescription)")
                alertMessage = "😡SIGNUP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Registration Success!")
                // TODO: Load ListView
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("😡LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "😡LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Login Success!")
                // TODO: Load ListView
            }
        }
    }
}
