import SwiftUI

struct ContentView: View {
    var body: some View {
        HotelRegistrationScreen()
    }
}

struct HotelRegistrationScreen: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var doorCode: String = ""
    @State private var numberOfGuests: Int = 1
    @State private var lengthOfStay: Int = 1
    @State private var isSmoking: Bool = false
    @State private var submitted: Bool = false
    @State private var registrationFeedback: Double = 3
    @State private var checkInDate: Date = Date()
    @State private var checkOutDate: Date = Date().addingTimeInterval(86400)
    @State private var showCheckInPicker: Bool = false
    @State private var showCheckOutPicker: Bool = false
    @State private var roomColor: Color = .blue
    
    // Predefined colors in alphabetical order
    let availableColors: [(name: String, color: Color)] = [
        ("Black", .black),
        ("Blue", .blue),
        ("Brown", .brown),
        ("Gray", .gray),
        ("Green", .green),
        ("Orange", .orange),
        ("Pink", .pink),
        ("Purple", .purple),
        ("Red", .red),
        ("White", .white),
        ("Yellow", .yellow)
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient - INSIDE HotelRegistrationScreen
            LinearGradient(
                gradient: Gradient(colors: [Color("backgroundColor"), Color("highlightColor").opacity(0.5)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Watermark - INSIDE HotelRegistrationScreen
            Image("mountainlandLogo")
                .resizable()
                .scaledToFit()
                .opacity(0.1)
                .frame(width: 350, height: 350)
            
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    HStack(spacing: 16) {
                        Image("mountainlandLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                        
                        Text("Mountainland Inn")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.highlight)
                            )
                    }
                    .padding(.top, 8)
                    
                    // Welcome Text
                    Text("Welcome!")
                        .font(.custom("Rockwell", size: 22))
                        .foregroundStyle(.text)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // First Name
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(.roundedBorder)
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(.text)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    .background(Color.white)
                                    .shadow(radius: 1)
                            )
                        
                        // Last Name
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(.roundedBorder)
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(.text)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    .background(Color.white)
                                    .shadow(radius: 1)
                            )
                        
                        // Door Code
                        SecureField("Door Code", text: $doorCode)
                            .textFieldStyle(.roundedBorder)
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(.text)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    .background(Color.white)
                                    .shadow(radius: 1)
                            )
                        
                        // Number of Guests Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Number of Guests:")
                                .font(.custom("Rockwell", size: 18))
                                .foregroundStyle(.text)
                            
                            Picker("Number of Guests", selection: $numberOfGuests) {
                                ForEach(1..<7) { guest in
                                    Text("\(guest)").tag(guest)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.highlight)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.9))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                            )
                            .onAppear {
                                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.highlight)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.text)], for: .normal)
                                UISegmentedControl.appearance().layer.borderWidth = 1
                                UISegmentedControl.appearance().layer.borderColor = UIColor(Color.highlight).cgColor
                            }
                        }
                        
                        // Length of Stay
                        HStack {
                            Text("Length of Stay: \(lengthOfStay) nights")
                                .font(.custom("Rockwell", size: 18))
                                .foregroundStyle(.text)
                            Spacer()
                            HStack(spacing: 0) {
                                Button { if lengthOfStay > 1 { lengthOfStay -= 1 } } label: {
                                    Text("-").font(.title2.bold())
                                        .frame(width: 40, height: 36)
                                        .foregroundColor(.text)
                                }
                                Rectangle().fill(Color.gray).frame(width: 1, height: 36)
                                Button { if lengthOfStay < 30 { lengthOfStay += 1 } } label: {
                                    Text("+").font(.title2.bold())
                                        .frame(width: 40, height: 36)
                                        .foregroundColor(.text)
                                }
                            }
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        }
                        
                        // Smoking Toggle
                        Toggle("Smoking Room", isOn: $isSmoking)
                            .font(.custom("Rockwell", size: 18))
                            .foregroundStyle(.text)
                        
                        // Check-In / Check-Out Dates
                        VStack(spacing: 16) {
                            HStack {
                                Text("Check-In:")
                                    .font(.custom("Rockwell", size: 18))
                                    .foregroundStyle(.text)
                                Spacer()
                                Button(action: { showCheckInPicker.toggle() }) {
                                    Text(checkInDate, style: .date)
                                        .font(.custom("Verdana", size: 16))
                                        .foregroundStyle(.text)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 1)
                                }
                                .sheet(isPresented: $showCheckInPicker) {
                                    NavigationView {
                                        DatePicker("Select Check-In", selection: $checkInDate, displayedComponents: .date)
                                            .datePickerStyle(.graphical)
                                            .padding()
                                            .navigationTitle("Check-In")
                                            .toolbar {
                                                ToolbarItem(placement: .confirmationAction) {
                                                    Button("Done") { showCheckInPicker = false }
                                                }
                                            }
                                    }
                                }
                            }
                            
                            HStack {
                                Text("Check-Out:")
                                    .font(.custom("Rockwell", size: 18))
                                    .foregroundStyle(.text)
                                Spacer()
                                Button(action: { showCheckOutPicker.toggle() }) {
                                    Text(checkOutDate, style: .date)
                                        .font(.custom("Verdana", size: 16))
                                        .foregroundStyle(.text)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 1)
                                }
                                .sheet(isPresented: $showCheckOutPicker) {
                                    NavigationView {
                                        DatePicker("Select Check-Out", selection: $checkOutDate, displayedComponents: .date)
                                            .datePickerStyle(.graphical)
                                            .padding()
                                            .navigationTitle("Check-Out")
                                            .toolbar {
                                                ToolbarItem(placement: .confirmationAction) {
                                                    Button("Done") { showCheckOutPicker = false }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Room Color Picker as Button
                        HStack {
                            Text("Pick Your Room Color:")
                                .font(.custom("Rockwell", size: 18))
                                .foregroundStyle(.text)
                            Spacer()
                            Menu {
                                ForEach(availableColors, id: \.name) { colorOption in
                                    Button(action: { roomColor = colorOption.color }) {
                                        HStack {
                                            Circle()
                                                .fill(colorOption.color)
                                                .frame(width: 20, height: 20)
                                            Text(colorOption.name)
                                                .font(.custom("Rockwell", size: 16))
                                                .foregroundStyle(.text)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(roomColor)
                                        .frame(width: 20, height: 20)
                                    Text(availableColors.first(where: { $0.color == roomColor })?.name ?? "Select")
                                        .font(.custom("Rockwell", size: 16))
                                        .foregroundStyle(.text)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(width: 150)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 1)
                            }
                        }
                        
                    } // End Form Fields VStack
                    .padding()
                    
                    // Submit Button
                    Button("Submit") { submitted.toggle() }
                        .font(.custom("Verdana", size: 24))
                        .padding()
                        .background(Color.highlight)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Feedback
                    if submitted {
                        VStack(spacing: 18) {
                            Text("Thank you for booking with us!")
                                .font(.custom("Rockwell", size: 24))
                                .foregroundStyle(.text)
                            Text("How would you rate your experience?")
                                .font(.custom("Rockwell", size: 16))
                                .foregroundStyle(.text)
                            Slider(value: $registrationFeedback, in: 1...5, step: 1)
                                .padding(.horizontal)
                            Text("\(Int(registrationFeedback))/5 ⭐️'s")
                                .font(.custom("Verdana", size: 16))
                                .foregroundStyle(.text)
                        }
                    }
                    
                    Color.clear.frame(height: 600)
                    
                } // End main VStack
                .padding()
            } // End ScrollView
        } // End ZStack
    }
}

#Preview {
    ContentView()
}
