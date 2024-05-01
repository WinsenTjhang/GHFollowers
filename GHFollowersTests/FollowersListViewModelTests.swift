//
//  FollowersListViewModelTest.swift
//  GHFollowersTests
//
//  Created by winsen on 01/05/24.
//

import XCTest
@testable import GHFollowers

class FollowersListViewModelTests: XCTestCase {
    
    private var mockNetworkManager = MockNetworkManager()
    
    func testFetchFollowers_Success() async throws {
        
        mockNetworkManager.shouldGetFollowersSucceed = true
        mockNetworkManager.mockFollowers = try StaticJSONDecoder.decode(file: "UserFollowersStaticData", type: [Follower].self)
        mockNetworkManager.shouldSimulateHasMoreFollowers = true
        
        let viewModel = FollowersListViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Wait for searchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.fetchFollowers()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        let staticData = try StaticJSONDecoder.decode(file: "UserFollowersStaticData", type: [Follower].self)
       
        XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        
        defer {
            XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        }
        
        XCTAssertEqual(viewModel.followers, staticData, "The returned response should be decoded properly")
        XCTAssertTrue(viewModel.hasMoreFollowers, "The view model should indicate there are more followers")
        XCTAssertEqual(viewModel.currentPage, 2, "The view model current page index should be 2")
        
    }
    
//    func testFetchFollowers_Failed() async throws {
//        mockNetworkManager.shouldGetFollowersSucceed = false
//        let viewModel = SearchViewModel(networkManager: mockNetworkManager)
//        let expectation = XCTestExpectation(description: "Wait for searchFollowers to complete")
//        
//        viewModel.completionHandler = {
//            expectation.fulfill()
//        }
//        
//        await viewModel.searchFollowers()
//        await fulfillment(of: [expectation], timeout: 2.0)
//        
//        XCTAssertFalse(viewModel.navigate)
//        XCTAssertTrue(viewModel.showAlert)
//        XCTAssertEqual(viewModel.alertMessage, "This user does not exist")
//    }
    
}

