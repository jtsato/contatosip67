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
        self.contatos.append(contato)
        self.saveContext();
    }
    
    public static func sharedInstance() -> ContatoDao {
        if self.defaultDAO == nil {
           self.defaultDAO = ContatoDao()
        }
        return defaultDAO
    }
    
    private override init(){
        super.init();
        self.carregaContatos();
    }
    
    public func getContatos() -> [Contato] {
        return self.contatos;
    }
    
    public func carregaContatos() -> Void {
        
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        busca.sortDescriptors = [orderPorNome]
        
        do {
            try self.contatos = self.persistentContainer.viewContext.fetch(busca)
        } catch let error as NSError {
            print("Fetch falhou: \(error.localizedDescription)");
        }
    }
    
    public func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return self.contatos[posicao];
    }
    
    func buscaPosicaoDoContato(contato: Contato) -> Int {
        return self.contatos.index(of: contato)!;
    }
    
    func contatoAdicionado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: buscaPosicaoDoContato(contato: contato), section: 0);
    }
    
    func contatoAtualizado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: buscaPosicaoDoContato(contato: contato), section: 0);
    }
    
    func remove(_ posicao:Int){
        self.persistentContainer.viewContext.delete(contatos[posicao])
        self.contatos.remove(at: posicao)
        self.saveContext()
        self.carregaContatos()
    }
    
    func novoContato() -> Contato {
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: persistentContainer.viewContext) as! Contato;
    }
}

