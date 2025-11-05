//
//  ContentView.swift
//  SOLID Lab
//
//  Created by AnnElaine on 10/28/25.
//

import SwiftUI
import Combine
import Observation

// PROTOCOLS
// - Interface Segregation (small, focused interfaces)
// - Dependency Inversion Principle (abstraction over implementation)
// - Protocol-Oriented Programming (behavior via protocols)

protocol PaymentProcessable {
    func process(amount: Double) -> Bool
}


protocol ReceiptSendable {
    func sendReceipt(_ message: String)
}


protocol Trackable {
    func track(_ event: String)
    
}


// IMPLEMENTATIONS
// Open/Closed Principle and Liskov Substitution Principle (all PaymentProcessable implementations are interchangeable

struct CreditCardProcessor: PaymentProcessable {
    func process(amount: Double) -> Bool { print("CreditCard: $\(amount)"); return true }
}

struct PayPalProcessor: PaymentProcessable {
    func process(amount: Double) -> Bool { print("PayPal: $\(amount)"); return true }
}

struct CryptoProcessor: PaymentProcessable {
    func process(amount: Double) -> Bool { print("Crypto: $\(amount)"); return true }
}

struct EmailReceipt: ReceiptSendable {
    func sendReceipt(_ message: String) { print("Email: \(message)") }
}

struct SMSReceipt: ReceiptSendable {
    func sendReceipt(_ message: String) {
        print("SMS: \(message)") }
}

struct ConsoleTrackable: Trackable {
    func track(_ event: String) {
        print("Analytics: \(event)")
    }
}


// SERVICES
// Single Responsibility Principle (Each service has one job) and Dependency Injection (Dependencies injected via init)

final class PaymentService: ObservableObject {
    private let processor: PaymentProcessable
    private let receipt: ReceiptSendable
    
    @Published var message = "Ready to process payments"
    @Published var balance: Double = 500.0
    
    init(processor: PaymentProcessable, receipt: ReceiptSendable) {
        self.processor = processor
        self.receipt = receipt
    }
    
    func pay(_ amount: Double, for description: String) {
        if processor.process(amount: amount) {
            balance -= amount
            message = "Paid $\(String(format: "%.2f", amount)) for \(description)"
            receipt.sendReceipt(message)
        } else {
            message = "Payment failed for \(description)"
        }
    }
}

@Observable
final class AnalyticsService {
    private let tracker: Trackable
    var eventLog = "Analytics ready"
    
    init(tracker: Trackable) { self.tracker = tracker }
    
    func record(_ event: String) {
        tracker.track(event)
        eventLog = "Tracked event: \(event)"
    }
}

final class ReportService {
    
// Interface Segregation and Dependency Inversion Principle
    func summary(payment: PaymentService, analytics: AnalyticsService) -> String {
        "Report Summary:\n\(payment.message)\n\(analytics.eventLog)"
    }
}

