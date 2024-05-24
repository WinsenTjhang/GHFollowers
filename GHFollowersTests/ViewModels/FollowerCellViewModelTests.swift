//
//  FollowerCellViewModelTests.swift
//  GHFollowersTests
//
//  Created by winsen on 21/05/24.
//

import XCTest
@testable import GHFollowers
import SwiftUI

class FollowerCellViewModelTests: XCTestCase {
    
    var viewModel: FollowerCellViewModel!
    private var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        viewModel = FollowerCellViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
    }
    
    func testDownloadImage_Success() async throws {
        
        mockNetworkManager.shouldDownloadImageSucceed = true
        let expectedImage = Image(uiImage: UIImage(named: "avatar-placeholder")!)
        let expectation = XCTestExpectation(description: "Wait for downloadImage to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        try await viewModel.downloadImage(for: "")
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(expectedImage, viewModel.image, "The returned image should match the expected image")
    }
    
    func testDownloadImage_Failed() async {
        mockNetworkManager.shouldDownloadImageSucceed = false
        
        do {
            let _ = try await viewModel.downloadImage(for: "")
            XCTFail("Expected downloadImage to throw error")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidStatusCode(statusCode: 404), "The error should be a 404 status code error")
        }
    }
    
}
