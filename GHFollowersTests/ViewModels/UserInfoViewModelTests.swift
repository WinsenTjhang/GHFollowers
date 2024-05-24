//
//  UserInfoViewModelTests.swift
//  GHFollowersTests
//
//  Created by winsen on 21/05/24.
//

import XCTest

@testable import GHFollowers

class UserInfoViewModelTests: XCTestCase {
    
    var viewModel: UserInfoViewModel!
    private var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        viewModel = UserInfoViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
    }
    
    func testGetUserInfo_Success() async throws {
        mockNetworkManager.shouldGetUserInfoSucceed = true
        
        let expectedUser = User.sampleUser
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.getUserInfo(of: "wStockhausen")
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.user, expectedUser, "The returned user should match the expected user")
        XCTAssertFalse(viewModel.showErrorAlert, "The view model should not show an error alert")
        XCTAssertEqual(viewModel.errorMessage, "", "The view model error message should be empty")
    }
    
    func testGetUserInfo_Failed() async throws {
        mockNetworkManager.shouldGetUserInfoSucceed = false
        
        let expectedUser = User.placeholder
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.getUserInfo(of: "")
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.user, expectedUser, "The returned user should match the expected user")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
}
