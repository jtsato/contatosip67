//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by ios6998 on 10/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation

class ContatoDao: CoreDataUtil {
    
    private var contatos = [Contato]()
    
    static private var defaultDAO: ContatoDao!
    
    var linhaDestaque:IndexPath?

    func adiciona(contato:Contato) -> Void {
        contatos.append(contato)  
    }
    
    public static func sharedInstance() -> ContatoDao {
        if defaultDAO == nil {
           defaultDAO = ContatoDao()
        }
        return defaultDAO
    }
    
    private override init(){
        super.init();
    }
    
    public func getContatos() -> [Contato] {
        return contatos;
    }
    
    public func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return contatos[posicao];
    }
    
    func buscaPosicaoDoContato(contato: Contato) -> Int {
        return contatos.index(of: contato)!;
    }
    
    func contatoAdicionado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: buscaPosicaoDoContato(contato: contato), section: 0);
    }
    
    func contatoAtualizado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: buscaPosicaoDoContato(contato: contato), section: 0);
    }
    
    func remove(_ posicao:Int){
        persistentContainer.viewContext.delete(contatos[posicao])
        contatos.remove(at: posicao);
    }
    
    func novoContato() -> Contato {
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: persistentContainer.viewContext) as! Contato;
    }
}

