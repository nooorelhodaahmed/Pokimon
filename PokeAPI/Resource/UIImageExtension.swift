//
//  UIImageExtension.swift
//  PokeAPI
//
//  Created by norelhoda on 04/11/2023.
//


import Foundation
import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}
