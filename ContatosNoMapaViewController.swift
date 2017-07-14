//
//  ContatosNoMapaViewController.swift
//  ContatosIP67
//
//  Created by ios6998 on 13/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation
import MapKit

class ContatosNoMapaViewController: UIViewController {

    @IBOutlet weak var mapa: MKMapView!
    
    let localizationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.localizationManager.requestAlwaysAuthorization()
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
    }
}
