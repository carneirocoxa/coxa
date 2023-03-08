//
//  Mensagem.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 06/02/23.
//

import Foundation

class Mensagem: Identifiable {
    var id: Int
    var resposta: Int
    var leuresposta: Bool
    var data: Date
    var ip: String
    var cadastro: Int
    var texto: String
    var ativo: Bool

    init(id: Int, resposta: Int, leuresposta: Bool, data: Date, ip: String, cadastro: Int, texto: String, ativo: Bool) {
        self.id = id
        self.resposta = resposta
        self.leuresposta = leuresposta
        self.data = data
        self.ip = ip
        self.cadastro = cadastro
        self.texto = texto
        self.ativo = ativo
    }
}
