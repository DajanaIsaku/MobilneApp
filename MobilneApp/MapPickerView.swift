//
//  MapPickerView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 14. 10. 2025..
//

import SwiftUI
import UIKit
import CoreLocation
import MapKit
struct MapPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var locationName: String
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.8176, longitude: 20.4569),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    struct MapPin: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: selectedCoordinate.map { [MapPin(coordinate: $0)] } ?? []
            ) { pin in
                MapMarker(coordinate: pin.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
            
            Button("Select This Location") {
                selectedCoordinate = region.center
                fetchLocationName(from: region.center) { name in
                    locationName = name
                    dismiss()
                }
            }
            .padding()
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    private func fetchLocationName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var name = ""
                if let street = placemark.thoroughfare {
                    name += street
                }
                if let city = placemark.locality {
                    name += name.isEmpty ? city : ", \(city)"
                }
                if let country = placemark.country {
                    name += name.isEmpty ? country : ", \(country)"
                }
                completion(name.isEmpty ? "Unknown location" : name)
            } else {
                completion("Unknown location")
            }
        }
    }
}
