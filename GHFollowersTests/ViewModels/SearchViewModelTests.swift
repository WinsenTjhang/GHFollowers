//
//  SearchViewModelTests.swift
//  GHFollowersTests
//
//  Created by winsen on 30/04/24.
//

import XCTest
@testable import GHFollowers

class SearchViewModelTests: XCTestCase {
    
    private var mockNetworkManager = MockNetworkManager()
    
    func testSearchFollowers_Success() async throws {
        mockNetworkManager.shouldGetFollowersSucceed = true
        let viewModel = SearchViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Wait for searchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.searchFollowers()
        await fulfillment(of: [expectation], timeout: 1.0)
       
        XCTAssertTrue(viewModel.navigate)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "")
    }
    
    func testSearchFollowers_Failed() async throws {
        mockNetworkManager.shouldGetFollowersSucceed = false
        let viewModel = SearchViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Wait for searchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.searchFollowers()
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertFalse(viewModel.navigate)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "This user does not exist")
    }
    
}

