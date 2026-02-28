//
//  MockAPIService.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/27/26.
//

import Foundation

final class MockAPIService: APIServiceProtocol {
    func fetchUsers(settings: Settings) async throws -> [User] {
        // Keeping a small delay for the loading spinner effect
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return [
            // AVERY COLEMAN
            User(
                name: Name(title: "Ms", first: "Avery", last: "Coleman"),
                picture: Picture(large: "https://randomuser.me/api/portraits/women/65.jpg", medium: "", thumbnail: ""),
                gender: "female",
                location: Location(street: Street(number: 742, name: "Maple Avenue"), city: "Denver", state: "Colorado", country: "United States", postcode: .int(80203)),
                email: "avery.coleman@example.com",
                login: Login(uuid: "c1a9f0e2-6b7a-4d3c-9e1a-1f0d2b3c4a5e", username: "averyc", password: "p@ssW0rd!", salt: "", md5: "", sha1: "", sha256: ""),
                registered: Registered(date: "2015-06-20T12:45:00Z", age: 10),
                dob: Dob(date: "1990-04-12T09:15:30Z", age: 35),
                phone: "(303)-555-0142",
                cell: "(720)-555-0198",
                idInfo: UserID(name: "SSN", value: "123-45-6789"), // FIXED: changed 'id' to 'idInfo'
                nat: "US"
            ),
            // LIAM NGUYEN
            User(
                name: Name(title: "Mr", first: "Liam", last: "Nguyen"),
                picture: Picture(large: "https://randomuser.me/api/portraits/men/32.jpg", medium: "", thumbnail: ""),
                gender: "male",
                location: Location(street: Street(number: 1289, name: "Oak Street"), city: "Seattle", state: "Washington", country: "United States", postcode: .int(98101)),
                email: "liam.nguyen@example.com",
                login: Login(uuid: "a8b7c6d5-e4f3-4a21-9c8d-7e6f5a4b3c2d", username: "liamn", password: "Secure*123", salt: "", md5: "", sha1: "", sha256: ""),
                registered: Registered(date: "2012-11-10T08:30:00Z", age: 13),
                dob: Dob(date: "1985-09-03T14:22:10Z", age: 40),
                phone: "(206)-555-0111",
                cell: "(425)-555-0177",
                idInfo: UserID(name: "SSN", value: "987-65-4321"), // FIXED: changed 'id' to 'idInfo'
                nat: "US"
            ),
            // ISABELLA ROSSI
            User(
                name: Name(title: "Mrs", first: "Isabella", last: "Rossi"),
                picture: Picture(large: "https://randomuser.me/api/portraits/women/44.jpg", medium: "", thumbnail: ""),
                gender: "female",
                location: Location(street: Street(number: 56, name: "Via Roma"), city: "Florence", state: "Tuscany", country: "Italy", postcode: .int(50122)),
                email: "isabella.rossi@example.com",
                login: Login(uuid: "11223344-5566-7788-99aa-bbccddeeff00", username: "isarossi", password: "R0ssi!2024", salt: "", md5: "", sha1: "", sha256: ""),
                registered: Registered(date: "2018-03-14T10:05:00Z", age: 7),
                dob: Dob(date: "1995-01-25T07:10:45Z", age: 31),
                phone: "+39-055-555-1234",
                cell: "+39-347-555-5678",
                idInfo: UserID(name: "CF", value: "RSSISB95A65F205X"), // FIXED: changed 'id' to 'idInfo'
                nat: "IT"
            ),
            // NOAH PATEL
            User(
                name: Name(title: "Mr", first: "Noah", last: "Patel"),
                picture: Picture(large: "https://randomuser.me/api/portraits/men/75.jpg", medium: "", thumbnail: ""),
                gender: "male",
                location: Location(street: Street(number: 908, name: "King Street"), city: "Toronto", state: "Ontario", country: "Canada", postcode: .int(10001)),
                email: "noah.patel@example.com",
                login: Login(uuid: "ffeeddcc-bbaa-9988-7766-554433221100", username: "noahp", password: "P@tel2025", salt: "", md5: "", sha1: "", sha256: ""),
                registered: Registered(date: "2016-09-05T09:20:00Z", age: 9),
                dob: Dob(date: "1992-12-08T16:40:00Z", age: 33),
                phone: "(416)-555-0133",
                cell: "(647)-555-0188",
                idInfo: UserID(name: "SIN", value: "123-456-789"), // FIXED: changed 'id' to 'idInfo'
                nat: "CA"
            )
        ]
    }
}

