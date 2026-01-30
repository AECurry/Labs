//
//  TDDStubLabTests.swift
//  TDDStubLabTests
//
//  Created by AnnElaine on 1/26/26.
//

import XCTest
@testable import TDDStubLab

// MARK: - Stub Service (Phase 2)
// Returns predetermined data without hitting the real API
class StubITunesService: iTunesService {
    let testItems: [StoreItem]
    
    init(testItems: [StoreItem]) {
        self.testItems = testItems
    }
    
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        return testItems
    }
}

// MARK: - Fake Service (Phase 2)
// Always throws an error
class FakeITunesService: iTunesService {
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        throw URLError(.notConnectedToInternet)
    }
}

// MARK: - Test Helper
// Helper to create test StoreItems easily
extension StoreItem {
    static func makeTestItem(name: String = "Test Song", artist: String = "Test Artist") -> StoreItem? {
        let jsonString = """
        {
            "trackName": "\(name)",
            "artistName": "\(artist)",
            "kind": "song"
        }
        """
        guard let jsonData = jsonString.data(using: .utf8),
              let item = try? JSONDecoder().decode(StoreItem.self, from: jsonData) else {
            return nil
        }
        return item
    }
}

// MARK: - Tests
final class TDDStubLabTests: XCTestCase {
    
    // Test 1: StubService returns predetermined data
    @MainActor
    func testStubService_ReturnsPredeterminedData() async throws {
        // Arrange
        guard let testItem = StoreItem.makeTestItem(name: "Test Song", artist: "Test Artist") else {
            XCTFail("Failed to create test item")
            return
        }
        let stubService = StubITunesService(testItems: [testItem])
        
        // Act
        let items = try await stubService.fetchItems(matching: ["term": "test"])
        
        // Assert
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "Test Song")
        XCTAssertEqual(items.first?.artist, "Test Artist")
    }
    
    // Test 2: FakeService always throws error
    func testFakeService_AlwaysThrowsError() async {
        // Arrange
        let fakeService = FakeITunesService()
        
        // Act & Assert
        do {
            _ = try await fakeService.fetchItems(matching: ["term": "test"])
            XCTFail("Should have thrown error")
        } catch {
            // Success - error was thrown as expected
            XCTAssertTrue(true)
        }
    }
}
