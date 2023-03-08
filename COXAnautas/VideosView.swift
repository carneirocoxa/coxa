//
//  VideosView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 27/02/23.
//

import SwiftUI

struct VideosView: View {
    struct Item: Identifiable {
        let id = UUID()
        let thumbnailURL: URL
        let title: String
        let description: String
        let videoURL: URL
    }

    // Use sua própria chave de API aqui
    let apiKey = "AIzaSyAmUTg69ytO3mTnvk3XzX8H8zgBVrHsAW4"
    let channelID = "UCynwTFoRCvZ5sySc-zp_9cw"
    let channelUP = "UUynwTFoRCvZ5sySc-zp_9cw"
    let maxResults = 10

    @State var items: [Item] = []

    var body: some View {
        NavigationStack {
            List(items) { item in
                ZStack {
                    NavigationLink(destination: VideoView(videoURL: item.videoURL)) {
                    }
                    VStack (alignment: .leading) {
                        AsyncImage(url: item.thumbnailURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray
                        }
                        //.frame(width: 160, height: 90)
                        
                        Text(item.title)
                            .font(.title)
                            .padding(.horizontal)
                            .foregroundColor(Color("Destaque"))
                        
                        Text(item.description)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.top, 1)
                            .padding(.bottom, 30)
                    }
                }
                .listRowInsets(EdgeInsets())
            }
            .onAppear {
                fetchVideos()
            }
        }
    }

    func fetchVideos() {
        guard let url = URL(string: "https://coxanautas.com.br/json/videos/") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching videos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
print(data)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(APIResponse.self, from: data)
                print(response)
                DispatchQueue.main.async {
                    self.items = response.items.map { item in
                        Item(
                            thumbnailURL: URL(string: item.snippet.thumbnails.medium.url)!,
                            title: item.snippet.title,
                            description: item.snippet.description.components(separatedBy: "\r\n\r\nSe").first ?? "",
                            videoURL: URL(string: "https://www.youtube.com/watch?v=\(item.snippet.resourceId.videoId)")!
                        )
                    }
                }
            } catch {
                print("Error decoding API response: \(error)")
            }
        }.resume()
    }

    struct APIResponse: Codable {
        let items: [Item]

        struct Item: Codable {
            let id: String
            let snippet: Snippet

            struct Snippet: Codable {
                let title: String
                let description: String
                let thumbnails: Thumbnails
                let resourceId: ResourceId

                struct Thumbnails: Codable {
                    let medium: Thumbnail

                    struct Thumbnail: Codable {
                        let url: String
                    }
                }
                
                struct ResourceId: Codable {
                    let videoId: String
                }
            }
        }
    }
}

struct VideosView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView()
    }
}
