//
//  NewsView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 27/02/23.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var newsFeed = NewsFeed()
    @State private var isRefreshing = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let refreshControl = UIRefreshControl()
    
    var body: some View {
        let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        
        NavigationStack {
            
            List(newsFeed.articles ?? []) { article in
                ZStack {
                    NavigationLink(destination: MensagemView(idUsuario: 1)) {
                    }
                    layout {
                        if let fotos = article.fotos {
                            AsyncImage(url: URL(string: fotos)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                            } placeholder: {
                                Color.gray
                            }
                            //                    .frame(width: 160, height: 90)
                        }
                        
                        VStack(alignment: .leading) {
                            
                            if let titulo = article.titulo {
                                Text(titulo)
                                    .font(.title)
                                    .padding(.horizontal)
                            }
                            if let gravata = article.gravata {
                                Text(gravata)
                                    .padding(.horizontal)
                                    .padding(.top, 1)
                                    .padding(.bottom, 30)
                            }
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
            }
            .refreshable {
                isRefreshing = true
                newsFeed.fetchArticles() /*{
                                          isRefreshing = false
                                          }*/
            }
        }
    }
}

class NewsFeed: ObservableObject {
    @Published var articles: [Article] = []
    
    init() {
        fetchArticles()
    }
    
    func fetchArticles() {
        //let url = URL(string: "https://coxanautas.com.br/app/json/noticia.json")!
        let url = URL(string: "https://coxanautas.com.br/json/noticias/")!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching articles: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Articles.self, from: data)
                            
                DispatchQueue.main.async {
                    self.articles = response.noticias
                }

            } catch {
                print("Error decoding articles: \(error.localizedDescription)")
                //print(error)
            }
        }
        task.resume()
    }
}

struct Article: Decodable, Identifiable {
    var id: Int
    var data: String
    var inclusao: String
    var url: String
    var titulo: String
    var retranca: String
    var gravata: String
    var texto: String
    var video: String
    var jogo: Int
    var enquete: Int
    var enquetecruzada: Int
    var disposicao: String
    var editoria: Int
    var editoria_url: String
    var editoria_nome: String
    var autor: Int
    var administrador: Int
    var destaque: Int
    var letreiro: Int
    var envioutelegram: Int
    var ativo: Int
    var obrigatorios: String
    var total: Int?
    var limite: Int?
    var fotos: String
}


struct Articles: Decodable {
    let noticias: [Article]
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
