//
//  AddLocationMapVC.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 29/04/23.
//

import UIKit
import MapKit

protocol AddLocationMapDelegate {
    func didAddedNewLocation(location: CLLocationCoordinate2D)
}

class AddLocationMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var delegate: AddLocationMapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(
                            target: self, action:#selector(handleAddLocation))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddLocationMapVC: MKMapViewDelegate {
    @objc func handleAddLocation(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        if let _ = self.delegate {
            self.delegate?.didAddedNewLocation(location: annotation.coordinate)
        }
    }
}
