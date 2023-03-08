//
//  ContentView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 30/01/23.
//
import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color("Fundo")
                .edgesIgnoringSafeArea(.all)
            Image("Logo")
                .resizable()
                .padding(.horizontal, 30.0)
                .scaledToFit()
                .frame(width: 300)
                .aspectRatio(contentMode: .fit)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            // próxima View que será exibida depois de 3 segundos
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
