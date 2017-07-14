//
//  GerenciadorDeAcoes.swift
//  ContatosIP67
//
//  Created by ios6998 on 12/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class GerenciadorDeAcoes: NSObject {
    
    let contato: Contato
    var controller: UIViewController!
    
    init(do contato:Contato){
        self.contato = contato
    }
    
    func exibirAcoes(em controller: UIViewController){
        
        self.controller = controller
        let alertView = UIAlertController(
            title: self.contato.nome, message: nil, preferredStyle: .actionSheet
        )
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default){action in self.ligar()}
        let exibirContatoNoMapa = UIAlertAction(title: "Visualizar no Mapa", style: .default){action in self.monstrarMapa()}
        let exibirSiteDoContato = UIAlertAction(title: "Visualizar site", style: .default){action in self.abrirSite()}
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatoNoMapa)
        alertView.addAction(exibirSiteDoContato)
        
        self.controller.present(alertView, animated: true, completion: nil)
    }
    
    private func ligar(){
        
        let device = UIDevice.current
        
        if device.model == "IPhone" {
            print("UUID \(device.identifierForVendor!)")
            abrirAplicativo(com: "tel:" + self.contato.telefone)
        } else {
            let alert = UIAlertController(title: "Impossível fazer ligações", message: "Seu dispositivo não é um IPhone", preferredStyle: .alert)
            self.controller.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func abrirSite(){
        
        var url = contato.site!
        
        if !url.hasPrefix("http://") {
            url = "http://" + url;
        }
        
        abrirAplicativo(com: url)
    }
    
    private func monstrarMapa(){
        
        let url = ("http://maps.google.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        abrirAplicativo(com: url)
    }
    
    private func abrirAplicativo(com url:String){
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    
    
}
