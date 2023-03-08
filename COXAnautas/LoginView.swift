//
//  LoginView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 27/02/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var senha = ""
    @State private var socio = false
    
    init()
    {
        // Recupera o email e a senha do UserDefaults
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        let senha = defaults.string(forKey: "senha")
        
        if (email != nil  && senha != nil && email != "" && senha != "")
        {
            Login (email: email ?? "", senha: senha ?? "")
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .padding(.horizontal, 30.0)
                    .scaledToFit()
                    .frame(width: 300)
                    .aspectRatio(contentMode: .fit)
                Spacer()
                TextField("E-mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title)
                    .padding()
                    .keyboardType(.emailAddress)
                SecureField("Senha", text: $senha)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title)
                    .padding()
                Button("Login") {
                    Login (email: email, senha: senha)
                }
                .padding()
                Spacer()
            }
            .padding()
            .background(Color("Fundo"))
            .fullScreenCover(isPresented: $socio) {
                MainView()
            }
        }
    }
    
    func Login (email: String, senha: String)
    {
        let params = ["email": email, "senha": senha]
        var components = URLComponents()
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        let url = URL(string: "https://coxanautas.com.br/json/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                
                print(String(data: data, encoding: .utf8))
                
                DispatchQueue.main.async {
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let user = try decoder.decode(Usuario.self, from: data)
                            if user.socio == "1" {
                                // Salva o email e a senha no UserDefaults
                                let defaults = UserDefaults.standard
                                defaults.set(user.email, forKey: "email")
                                defaults.set(user.senha, forKey: "senha")
                                
                                socio = true
                                //                                            let mainView = MainView()
                                //                                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mainView)
                            }
                        } catch {
                            print("Error decoding Users: \(error)")
                        }
                    }.resume()
                }
                
            }.resume()
        }
    }
}

struct Usuario: Decodable {
    let socio: String
    let id: String
    let nome: String
    let exibicao: String
    let email: String
    let nivel: String
    let nascimento: String
    let login: Int
    let senha: String
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
