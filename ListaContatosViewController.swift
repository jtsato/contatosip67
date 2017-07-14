//
//  ListaContatosViewController.swift
//  ContatosIP67
//
//  Created by ios6998 on 11/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class ListaContatosViewController: UITableViewController, FormularioContatoViewControllerDelegate {
    
    static let cellId = "cell";
    
    var contatoDao: ContatoDao
    
    var linhaDestaque: IndexPath?
    
    required init?(coder aDecoder: NSCoder){
        self.contatoDao = ContatoDao.sharedInstance();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurarEditButton()
        
        let clicLongo = UILongPressGestureRecognizer(target: self, action: #selector(exibirMaisAcoes))
        self.tableView.addGestureRecognizer(clicLongo)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func exibirMaisAcoes(gesture: UIGestureRecognizer){
        if (gesture.state == .began){
            let ponto = gesture.location(in: self.tableView)
            if let indexPath:IndexPath = self.tableView.indexPathForRow(at: ponto) {
                let contatoSelecionado = self.contatoDao.buscaContatoNaPosicao(indexPath.row)
                print(contatoSelecionado)
                let acoes = GerenciadorDeAcoes(do: contatoSelecionado)
                acoes.exibirAcoes(em: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contatoDao.getContatos().count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewController.cellId)
        
        if (cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier:  ListaContatosViewController.cellId)
        }
        
        let contato = ContatoDao.sharedInstance().buscaContatoNaPosicao(indexPath.row)
        
        cell!.textLabel?.text = contato.nome;
        
        // Configure the cell...
        
        return cell!;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        if let linha = self.linhaDestaque {
            self.tableView.selectRow(at: linha, animated: true, scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                self.tableView.deselectRow(at: linha, animated: true)
                self.linhaDestaque = .none
            }
        }
    }
    
    func configurarEditButton(){
        if (contatoDao.getContatos().count == 0){
            self.navigationItem.leftBarButtonItem = nil;
        } else {
            self.navigationItem.leftBarButtonItem = self.editButtonItem;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.tableView.selectRow(at: linhaDestaque, animated: true, scrollPosition: .middle)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uiStoryboardMain = UIStoryboard(name: "Main", bundle: nil);
        let form = uiStoryboardMain.instantiateViewController(withIdentifier: "formulario") as! FormularioViewController
        let contato = contatoDao.getContatos()[indexPath.row]
        form.contatoSelecionado(contato)
        form.delegate = self;
        self.navigationController?.pushViewController(form, animated: true)
    }
    
    func contatoAdicionado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: contatoDao.buscaPosicaoDoContato(contato: contato), section: 0);
        print("Contato adicionado: \(contato.nome)")
    }
    
    func contatoAtualizado(contato: Contato) {
        self.linhaDestaque = IndexPath(row: contatoDao.buscaPosicaoDoContato(contato: contato), section: 0);
        print("Contato atualizado: \(contato.nome)")
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.contatoDao.remove(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.configurarEditButton()
        }
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FormSegue" {
            if let form = segue.destination as? FormularioViewController {
                form.delegate = self
            }
        }
        
    }
    
    
}
