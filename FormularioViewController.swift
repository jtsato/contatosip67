//
//  FormularioViewController.swift
//  ContatosIP67
//
//  Created by ios6998 on 10/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class FormularioViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nome        : UITextField!
    @IBOutlet weak var telefone    : UITextField!
    @IBOutlet weak var endereco    : UITextField!
    @IBOutlet weak var site        : UITextField!
    @IBOutlet weak var latitude    : UITextField!
    @IBOutlet weak var longitude   : UITextField!
    
    @IBOutlet weak var imageView   : UIImageView!
    @IBOutlet weak var loading     : UIActivityIndicatorView!
    
    var contato: Contato!
    
    var delegate: FormularioContatoViewControllerDelegate?
    
    @IBAction func criaContato(){
        self.pegaDadosDoFormulario();
        ContatoDao.sharedInstance().adiciona(contato: contato)
        _ = self.delegate?.contatoAdicionado(contato: contato)
        _ = self.navigationController?.popViewController(animated: true);
    }
    
    func contatoSelecionado(_ contato:Contato){
        self.contato = contato;
    }
    
    override func viewDidLoad() {
        
        if (self.contato != nil){
            self.nome!.text = self.contato.nome;
            self.telefone!.text = self.contato.telefone;
            self.endereco!.text = self.contato.endereco;
            self.site!.text = self.contato.site;
            self.latitude.text = contato.latitude?.description
            self.longitude.text = contato.longitude?.description
            
            if let foto = self.contato.foto {
                self.imageView.image = foto
            }
            
            let botaoConfirmar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizar))
            self.navigationItem.rightBarButtonItem = botaoConfirmar
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        self.imageView.addGestureRecognizer(tap)
    }
    
    func selecionarFoto(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let alert = UIAlertController(title: "Escolha foto do contato", message: self.contato.nome, preferredStyle: .actionSheet)
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let tirarFoto = UIAlertAction(title: "Tirar Foto", style: .default) {
                (action) in self.pegarImage(da: .camera)
            }
            let escolherFoto = UIAlertAction(title: "Escolher da Biblioteca", style: .default){
                (action) in self.pegarImage(da: .photoLibrary)
            }
            alert.addAction(cancelar)
            alert.addAction(tirarFoto)
            alert.addAction(escolherFoto)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.pegarImage(da: .photoLibrary)
        }
    }
    
    func pegarImage(da sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String:AnyObject]){
        if let imagemSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imagemSelecionada
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func atualizar(){
        self.pegaDadosDoFormulario()
        _ = self.delegate?.contatoAdicionado(contato: contato)
        _ = self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func pegaDadosDoFormulario() -> Void {
        
        if (self.contato == nil){
            self.contato = Contato()
        }
        
        self.contato.nome = self.nome.text!
        self.contato.telefone = self.telefone.text!
        self.contato.endereco = self.endereco.text!
        self.contato.site = self.site.text!
        self.contato.foto = self.imageView.image
        
        if let latitude = Double(self.latitude.text!){
            self.contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!){
            self.contato.longitude = longitude as NSNumber
        }
        
    }
    
    @IBAction func buscaCoordenadas(sender: UIButton){
        self.loading.startAnimating();
        sender.isEnabled = false;
        let geocoder = CLGeocoder();
        geocoder.geocodeAddressString(self.endereco.text!) { (resultado, error) in
            if error == nil && (resultado?.count)! > 0 {
                let placemark = resultado![0]
                let coordenada = placemark.location!.coordinate
                self.latitude.text = coordenada.latitude.description
                self.longitude.text = coordenada.longitude.description
            }
            self.loading.stopAnimating();
            sender.isEnabled = true;
        }
    }
}
