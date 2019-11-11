//
//  ViewController.swift
//  cm-direcciones
//
//  Created by 2020-1 on 10/9/19.
//  Copyright © 2019 UltraCode. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var localidades: [Localidad]!
    var direcciones: [Direccion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        mapa.delegate = self
        //let inicioLocation = CLLocationCoordinate2D(latitude: localidades[1].lat, longitude: localidades[1].long)
        
        //let intermedioLocation = CLLocationCoordinate2D(latitude: localidades[1].lat, longitude: localidades[1].long)
        
        let destinoLocation = CLLocationCoordinate2D(latitude: 19.3248272, longitude: -99.1847808)
        
        let inicioPin = direcciones[3]
        
        let destinoPin = Direccion(title: "Contaduria", subtitle: "Cafeterìa", coordinate: destinoLocation)
        
        //let unPin = Direccion(title: "Nose", subtitle: "Algun lugar", coordinate: intermedioLocation)
        
        //mapa.addAnnotation(inicioPin)
        //mapa.addAnnotation(destinoPin)
        //mapa.addAnnotation(unPin)
        
        for loc in direcciones{
            mapa.addAnnotation(loc)
        }
        
        //Agregando placemark
        
        let inicioPlaceMark = MKPlacemark(coordinate: direcciones[3].coordinate)
        let destinoPlaceMark = MKPlacemark(coordinate: destinoLocation)
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: inicioPlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinoPlaceMark)
        
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate{ (response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let directionResponse = response else{
                return
            }
            
            let ruta = directionResponse.routes.first
            
            self.mapa.addOverlay(ruta!.polyline)
            
            let rect = ruta?.polyline.boundingMapRect
            self.mapa.setRegion(MKCoordinateRegion(rect!), animated: true)
        }

    }
    
    func getData(){
        if let url = Bundle.main.url(forResource: "localidades", withExtension: "json"){
            do{
                var coordTmp: CLLocationCoordinate2D!
                var direccionTmp: Direccion!
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Resultado.self, from: data)
                for res in jsonData.results{
                    coordTmp = CLLocationCoordinate2D(latitude: res.lat, longitude:  res.long)
                    direccionTmp = Direccion(title: res.title, subtitle: res.subtitle, coordinate: coordTmp)
                    self.direcciones.append(direccionTmp)
                }
            } catch{
                print("error: \(error)")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let linea = MKPolylineRenderer(overlay: overlay)
        linea.strokeColor = .blue
        linea.lineWidth = 0.4
        return linea
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.coordinate.longitude
        {
            print("Se selecciono \(String(describing: annotationTitle))")
        }
    }

}

