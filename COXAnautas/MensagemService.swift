import Foundation

class MensagemService: ObservableObject {
    @Published var mensagens = [Mensagem]()
    
    func fetchMensagens(completion: @escaping ([Mensagem]) -> Void) {
        let urlString = "https://coxanautas.com.br/app/json/mensagem.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch mensagens:", error)
                return
            }

            guard let data = data else { return }
            let mensagens = self.parseMensagens(from: data)
            completion(mensagens)
        }.resume()
    }

    private func parseMensagens(from data: Data) -> [Mensagem] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let mensagensData = try decoder.decode([MensagemData].self, from: data)
            let mensagens = mensagensData.map { Mensagem(id: $0.id, resposta: $0.resposta, leuresposta: $0.leuresposta, data: $0.data, ip: $0.ip, cadastro: $0.cadastro, texto: $0.texto, ativo: $0.ativo) }
            return mensagens
        } catch let error {
            print("Failed to parse mensagens:", error)
            return []
        }
    }
}

struct MensagemData: Decodable {
    let id: Int
    let resposta: Int
    let leuresposta: Bool
    let data: Date
    let ip: String
    let cadastro: Int
    let texto: String
    let ativo: Bool
}
