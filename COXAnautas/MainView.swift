//
//  MainView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 27/02/23.
//

import SwiftUI

struct MainView: View {
    init() {
        //UITabBar.appearance().backgroundColor = UIColor(Color("Fundo"))
        //UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .padding(.horizontal, 30.0)
                .scaledToFit()
                .frame(width: 300)
                .aspectRatio(contentMode: .fit)

            TabView {
                Group {
                    VideosView().tabItem {
                        Image(systemName: "play.circle.fill")
                        Text("Vídeos")
                    }
                    
                    NewsView().tabItem {
                        Image(systemName: "globe")
                        Text("Notícias")
                    }
                    MensagemView(idUsuario: 1).tabItem {
                        Image(systemName: "message")
                        Text("Bate-papo")
                    }
                }
            }
            .accentColor(Color("Destaque"))
        }
        .background(Color("Fundo"))
    }
}
/*
class Connectivity {
  class func isConnectedToInternet() -> Bool {
    guard let url = URL(string: "https://google.com") else { return false }
    let request = URLRequest(url: url)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      guard let _ = data, error == nil else { return }
    }
    task.resume()
    return true
  }
}
*/

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
