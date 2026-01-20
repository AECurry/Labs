//
//  PlacePinScreen.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/15/26.
//

import SwiftUI
import MapKit

struct PlacePinScreen: View {
    let trip: Trip
    let onComplete: () -> Void
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.0, longitude: -77.0),
            span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0)
        )
    )
    @State private var currentMapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.0, longitude: -77.0),
        span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0)
    )
    @State private var pinCoordinate: CLLocationCoordinate2D?
    @State private var navigateToSetup = false
    
    private var hasPin: Bool { pinCoordinate != nil }
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let coordinate = pinCoordinate {
                        Annotation("", coordinate: coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.red)
                                .background(
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 28, height: 28)
                                )
                                .shadow(radius: 5)
                        }
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onMapCameraChange { context in
                    currentMapRegion = context.region
                }
                .onTapGesture { screenPosition in
                    if let coordinate = proxy.convert(screenPosition, from: .local) {
                        withAnimation {
                            pinCoordinate = coordinate
                            let newRegion = MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                            )
                            cameraPosition = .region(newRegion)
                            currentMapRegion = newRegion
                        }
                    }
                }
                .ignoresSafeArea()
            }
            
            VStack {
                VStack(spacing: 12) {
                    Text(hasPin ? "Pin Placed!" : (trip.journalEntries.isEmpty ? "Place Your First Pin" : "Place Your Next Pin"))
                            .font(.title2)
                            .fontWeight(.bold)
                    
                    Text("Tap on the map to place a pin")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                Button {
                    zoomIn()
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(.blue))
                        .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
                }
                
                Button {
                    zoomOut()
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(.blue))
                        .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
                }
                
                Spacer().frame(height: 40)
                
                if hasPin {
                    Button {
                        withAnimation {
                            pinCoordinate = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(.red))
                            .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
                    }
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    if !hasPin {
                        Button {
                            withAnimation {
                                pinCoordinate = currentMapRegion.center
                            }
                        } label: {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                Text("Drop Pin Here")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    } else {
                        Button {
                            navigateToSetup = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Next")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToSetup) {
            if let coordinate = pinCoordinate {
                SetUpPinScreen(
                    trip: trip,
                    coordinate: coordinate,
                    onComplete: onComplete
                )
            }
        }
    }
    
    private func zoomIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            let newLatDelta = max(currentMapRegion.span.latitudeDelta * 0.5, 0.001)
            let newLonDelta = max(currentMapRegion.span.longitudeDelta * 0.5, 0.001)
            
            let newSpan = MKCoordinateSpan(
                latitudeDelta: newLatDelta,
                longitudeDelta: newLonDelta
            )
            
            let newRegion = MKCoordinateRegion(
                center: currentMapRegion.center,
                span: newSpan
            )
            
            cameraPosition = .region(newRegion)
            currentMapRegion = newRegion
        }
    }
    
    private func zoomOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            let newLatDelta = min(currentMapRegion.span.latitudeDelta * 2.0, 180.0)
            let newLonDelta = min(currentMapRegion.span.longitudeDelta * 2.0, 360.0)
            
            let newSpan = MKCoordinateSpan(
                latitudeDelta: newLatDelta,
                longitudeDelta: newLonDelta
            )
            
            let newRegion = MKCoordinateRegion(
                center: currentMapRegion.center,
                span: newSpan
            )
            
            cameraPosition = .region(newRegion)
            currentMapRegion = newRegion
        }
    }
}

#Preview {
    NavigationStack {
        PlacePinScreen(
            trip: Trip(name: "My Trip", startDate: Date()),
            onComplete: {}
        )
    }
}
