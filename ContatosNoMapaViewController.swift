//
//  ContatosNoMapaViewController.swift
//  ContatosIP67
//
//  Created by ios6998 on 13/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation
import MapKit

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var contatos: [Contato] = Array()
    let contatoDao: ContatoDao = ContatoDao.sharedInstance()
    
    let localizationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.mapa.delegate = self
        self.localizationManager.requestAlwaysAuthorization()
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier:String = "pino"
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
        } else {
            pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let contato = annotation as? Contato {
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            let frame = CGRect(x:0.0, y:0.0, width: 32.0, height:32.0)
            let imagemContato = UIImageView(frame: frame)
            imagemContato.image = contato.foto
            pino.leftCalloutAccessoryView = imagemContato
        }
        
        return pino
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contatos = contatoDao.getContatos()
        self.mapa.addAnnotations(self.contatos)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapa.removeAnnotations(self.contatos)
    }
}
