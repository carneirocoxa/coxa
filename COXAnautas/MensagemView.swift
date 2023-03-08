//
//  MensagemView.swift
//  COXAnautas
//
//  Created by Marcelo Carneiro on 06/02/23.
//

import SwiftUI

struct MensagemRow: View {
    var mensagem: Mensagem
    var isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
                Text(mensagem.texto)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            } else {
                Text(mensagem.texto)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

struct MensagemList: View {
    var mensagens: [Mensagem]
    var currentUserID: Int

    var body: some View {
        List(mensagens) { mensagem in
            MensagemRow(mensagem: mensagem, isCurrentUser: mensagem.cadastro == currentUserID)
        }
    }
}

struct MensagemView: View {
    @ObservedObject var service = MensagemService()
    var idUsuario: Int

    var body: some View {
        List(service.mensagens) { mensagem in
            HStack {
                if mensagem.cadastro == self.idUsuario {
                    Spacer()
                    Text(mensagem.texto)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                } else {
                    Text(mensagem.texto)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
        }
    }
}

/*struct MensagemView: View {
    var mensagens: [Mensagem]
    var currentUserID: Int

    var body: some View {
        MensagemList(mensagens: mensagens, currentUserID: currentUserID)
    }
}*/

struct MensagemView_Previews: PreviewProvider {
    static var previews: some View {
        MensagemView(idUsuario: 1)
    }
}
