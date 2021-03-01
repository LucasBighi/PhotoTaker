//
//  PhotoTakerTests.swift
//  PhotoTakerTests
//
//  Created by Lucas Bighi on 01/03/21.
//

import XCTest
@testable import PhotoTaker

class PhotoTakerTests: XCTestCase {
    
    var service: PhotoService!
    
    override func setUp() {
        service = PhotoService(assetThumbnailSize: .zero)
    }
}
