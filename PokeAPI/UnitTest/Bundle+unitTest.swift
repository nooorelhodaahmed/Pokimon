//
//  Bundle+unitTest.swift
//  PokeAPITests
//
//  Created by norelhoda on 04/11/2023.
//

import Foundation
extension Bundle {
    public class var unitTest :Bundle {
        return Bundle(for: AuthServiceTests.self)
    }
}
