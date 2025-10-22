//
//  ContentView.swift
//  LifeCycle Lab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var eventTracker = EventTracker()  
    @State private var showingSecondView = false
    @State private var showingFakeApp = false
    @State private var scenePhase = ScenePhase.active
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 80)
                        
                        HeaderView()
                     
                        HStack(spacing: 15) {
                            StatusCardView(title: "Current View", status: "Main", color: .blue)
                            StatusCardView(title: "Events Count", status: "\(eventTracker.events.count)", color: .green)  // Use eventTracker.events.count
                            StatusCardView(title: "Scene Phase", status: "\(String(describing: scenePhase))", color: .purple)
                        }
                        .padding(.horizontal)
                        
                        EventsLogView(events: eventTracker.events) {  // Use eventTracker.events
                            eventTracker.clearEvents()  // Use the method from EventTracker
                        }
                        
                        VStack(spacing: 15) {
                            Button("Show Second View") {
                                showingSecondView = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
                
                if !showingFakeApp {
                    NotificationBannerView(
                        isShowingSimulation: $showingFakeApp,
                        events: $eventTracker.events  // Use eventTracker.events
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSecondView) {
            SecondView(events: $eventTracker.events)  // Use eventTracker.events
        }
        .fullScreenCover(isPresented: $showingFakeApp) {
            FakeAppView(
                isPresented: $showingFakeApp,
                events: $eventTracker.events  // Use eventTracker.events
            )
        }
        .onAppear {
            eventTracker.addEvent("ContentView appeared")  // Use eventTracker method
        }
        .onDisappear {
            eventTracker.addEvent("ContentView disappeared")  // Use eventTracker method
        }
    }
}
