//
//  SpaceshipScreen.swift
//  State Spaceship (aka Stateship)
//
//  Created by Jane Madsen on 9/29/25.
//

import SwiftUI

// Central Computer
@Observable
class ShipComputer {
    var availablePower = 10
    var heading = ""
    var weaponsPower = 0
    var shieldPower = 0
    var enginePower = 0
}

// Crew Members
enum Crew: String, CaseIterable {
    case dog, cat, lizard, hare
    
    var icon: Image {
        switch self {
        case .dog: return Image(systemName: "dog")
        case .cat: return Image(systemName: "cat")
        case .lizard: return Image(systemName: "lizard")
        case .hare: return Image(systemName: "hare")
        }
    }
}

// Spaceship Screen
struct SpaceshipScreen: View {
    @State private var computer = ShipComputer() // CHANGED: @State instead of @StateObject
    
    @State private var crewAssignments: [String: Crew?] = [
        "Helm": .dog,
        "Weapons": .cat,
        "Shield": .lizard,
        "Engine": .hare
    ]
    
    @State private var helmInChair = true
    @State private var weaponsInChair = true
    @State private var shieldInChair = true
    @State private var engineInChair = true
    
    private func binding(for station: String) -> Binding<Crew?> {
        Binding(
            get: { crewAssignments[station] ?? nil },
            set: { crewAssignments[station] = $0 }
        )
    }
    
    var body: some View {
        ZStack {
            // Gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white, location: 0.0),
                    .init(color: .white, location: 0.1),
                    .init(color: .green, location: 0.6),
                    .init(color: .blue, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Form with built-in scrolling
            Form {
                // Helm Station Title/Container (Active)
                Section(header: Text("Helm Station")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    HelmStation(
                        crewMember: binding(for: "Helm"),
                        inChair: $helmInChair
                    )
                }
                // Weapons Station Title/Container (Active)
                Section(header: Text("Weapons Station")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    WeaponsStation(
                        crewMember: binding(for: "Weapons"),
                        inChair: $weaponsInChair
                    )
                }
                // Shield Station Title/Container (Active)
                Section(header: Text("Shield Station")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    ShieldStation(
                        crewMember: binding(for: "Shield"),
                        inChair: $shieldInChair
                    )
                }
                // Engine Station Title/Container (Active)
                Section(header: Text("Engine Station")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    EngineStation(
                        crewMember: binding(for: "Engine"),
                        inChair: $engineInChair
                    )
                }
                // Power View Title/Container (Active)
                Section(header: Text("Power")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    VStack {
                        Text("Available Power: \(computer.availablePower)")
                            .font(.headline)
                        ProgressView(value: Double(computer.availablePower), total: 10)
                            .progressViewStyle(.linear)
                            .tint(.blue)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
            }
            .scrollContentBackground(.hidden)
        }
        .environment(computer) // CHANGED: .environment instead of .environmentObject
    }
    
    // CrewChair
    struct CrewChair: View {
        @Binding var crewMember: Crew?
        @Binding var inChair: Bool
        
        var body: some View {
            Menu {
                Button("None") {
                    crewMember = nil
                    inChair = false
                }
                ForEach(Crew.allCases, id: \.self) { crew in
                    Button {
                        crewMember = crew
                        inChair = true
                    } label: {
                        HStack { crew.icon; Text(crew.rawValue.capitalized) }
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle().stroke((inChair && crewMember != nil) ? Color.blue : Color.gray, lineWidth: 2)
                        )
                    if inChair, let crew = crewMember {
                        crew.icon.foregroundColor(.blue).font(.system(size: 20))
                    } else {
                        Image(systemName: "person.slash").foregroundColor(.gray).font(.system(size: 20))
                    }
                }
            }
            .padding(5)
        }
    }
    
    // Helm Station UI
    struct HelmStation: View {
        @Environment(ShipComputer.self) private var computer // CHANGED: @Environment instead of @Bindable
        @Binding var crewMember: Crew?
        @Binding var inChair: Bool
        
        var body: some View {
            HStack {
                CrewChair(crewMember: $crewMember, inChair: $inChair)
                TextField("Heading", text: Binding(
                    get: { computer.heading },
                    set: { computer.heading = $0 }
                ))
                .disabled(!inChair)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    // Weapons Station UI
    struct WeaponsStation: View {
        @Environment(ShipComputer.self) private var computer // CHANGED: @Environment instead of @EnvironmentObject
        @Binding var crewMember: Crew?
        @Binding var inChair: Bool
        
        @State private var localWeaponsPower = 0
        
        var body: some View {
            HStack {
                CrewChair(crewMember: $crewMember, inChair: $inChair)
                VStack {
                    Stepper("Weapons Power: \(localWeaponsPower)", value: $localWeaponsPower, in: 0...10)
                        .disabled(!inChair || computer.availablePower <= 0)
                        .onChange(of: localWeaponsPower) {
                            let maxPower = max(0, 10 - (computer.shieldPower + computer.enginePower))
                            if localWeaponsPower > maxPower { localWeaponsPower = maxPower }
                            computer.weaponsPower = localWeaponsPower
                            computer.availablePower = 10 - (computer.weaponsPower + computer.shieldPower + computer.enginePower)
                        }
                    Button("Fire!") { if localWeaponsPower > 0 { print("PEW!") } }
                        .disabled(!inChair || localWeaponsPower <= 0)
                        .tint(localWeaponsPower > 0 && inChair ? .red : .gray.opacity(0.5))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    // Shield Station UI
    struct ShieldStation: View {
        @Environment(ShipComputer.self) private var computer // CHANGED: @Environment instead of @EnvironmentObject
        @Binding var crewMember: Crew?
        @Binding var inChair: Bool
        
        @State private var localShieldPower = 0
        
        var body: some View {
            HStack {
                CrewChair(crewMember: $crewMember, inChair: $inChair)
                Stepper("Shield Power: \(localShieldPower)", value: $localShieldPower, in: 0...10)
                    .disabled(!inChair || computer.availablePower <= 0)
                    .onChange(of: localShieldPower) {
                        let maxPower = max(0, 10 - (computer.weaponsPower + computer.enginePower))
                        if localShieldPower > maxPower { localShieldPower = maxPower }
                        computer.shieldPower = localShieldPower
                        computer.availablePower = 10 - (computer.weaponsPower + computer.shieldPower + computer.enginePower)
                    }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    // Engine Station UI
    struct EngineStation: View {
        @Environment(ShipComputer.self) private var computer // CHANGED: @Environment instead of @EnvironmentObject
        @Binding var crewMember: Crew?
        @Binding var inChair: Bool
        
        @State private var localEnginePower = 0
        
        var body: some View {
            HStack {
                CrewChair(crewMember: $crewMember, inChair: $inChair)
                Stepper("Engine Power: \(localEnginePower)", value: $localEnginePower, in: 0...10)
                    .disabled(!inChair || computer.availablePower <= 0)
                    .onChange(of: localEnginePower) {
                        let maxPower = max(0, 10 - (computer.weaponsPower + computer.shieldPower))
                        if localEnginePower > maxPower { localEnginePower = maxPower }
                        computer.enginePower = localEnginePower
                        computer.availablePower = 10 - (computer.weaponsPower + computer.shieldPower + computer.enginePower)
                    }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

#Preview {
    SpaceshipScreen()
}
