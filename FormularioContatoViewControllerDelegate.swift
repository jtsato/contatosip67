//
//  FormularioContatoViewControllerDelegate.swift
//  ContatosIP67
//
//  Created by ios6998 on 12/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {
    func contatoAtualizado(contato:Contato)
    func contatoAdicionado(contato:Contato)
}
