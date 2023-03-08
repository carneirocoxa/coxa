//
//  VideoView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 30/01/23.
//

import SwiftUI
import WebKit

struct VideoView: View {
    @State var videoURL: URL
    @State private var comments: [Comment] = []
    
    var body: some View {
        VStack {
            if videoURL != nil {
                VideoPlayer(videoURL: videoURL)
                    .aspectRatio(16/9, contentMode: .fit)
            } else {
                Text("Carregando vídeo...")
            }
            List(comments) { comment in
                Text(comment.text)
            }
        }
        .onAppear() {
            fetchComments()
        }
    }
          
    func fetchComments() {
        // Buscar comentários do vídeo aqui usando a API do YouTube
        // Por exemplo:
        self.comments = [
            Comment(text: "Ótimo vídeo!"),
            Comment(text: "Aprendi muito!"),
            Comment(text: "Me inscrevi no canal!"),
        ]
    }

    struct VideoPlayer: UIViewRepresentable {
        let videoURL: URL
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.load(URLRequest(url: videoURL))
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
        }
    }

    struct Comment: Identifiable {
        let id = UUID()
        let text: String
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(videoURL: URL(string: "https://www.youtube.com/embed/iQ76xud5e88")!
        )
    }
}
