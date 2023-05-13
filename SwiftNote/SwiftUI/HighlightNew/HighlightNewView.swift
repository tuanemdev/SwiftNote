//
//  HighlightNewView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 13/05/2023.
//

import SwiftUI
import MapKit

struct HighlightNewView: View {
    
    /// Apple Park Region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
    
    var body: some View {
        TabView {
            GeometryReader { proxy in
                let safeArea = proxy.safeAreaInsets
                
                Map(coordinateRegion: $region)
                    /// Top Safe Area View
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: safeArea.top)
                    }
                    .ignoresSafeArea()
                    /// Sample Buttons
                    .overlay(alignment: .topTrailing) {
                        VStack {
                            Button {
                                print("Location Action")
                            } label: {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.black)
                                    }
                            }
                            .showCase(
                                order: 0,
                                title: "My Current Location",
                                cornerRadius: 10,
                                style: .continuous
                            )
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                print("Like Action")
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.red)
                                    }
                            }
                            .showCase(
                                order: 1,
                                title: "Favourite Location",
                                cornerRadius: 10,
                                style: .continuous
                            )
                        }
                        .padding(15)
                    }
            }
            .tabItem {
                Image(systemName: "macbook.and.iphone")
                Text("Device")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)

            Text("List Items")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Items")
                }

            Text("Persion Infomations")
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Me")
                }
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(
                        order: 2,
                        title: "My Devices",
                        cornerRadius: 10,
                        style: .continuous,
                        scale: 1.5
                    )
                    .frame(maxWidth: .infinity)
                
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(
                        order: 4,
                        title: "Location Enabled Tag's",
                        cornerRadius: 10,
                        style: .continuous,
                        scale: 1.5
                    )
                    .frame(maxWidth: .infinity)
                
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(
                        order: 3,
                        title: "Personal Info",
                        cornerRadius: 10,
                        style: .continuous,
                        scale: 1.5
                    )
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(.clear)
            .allowsHitTesting(false)
        }
        .modifier(ShowCaseRoot(showHighlights: true) {
            print("finised Onboarding")
        })
    }
}

struct HighlightNewView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightNewView()
    }
}
