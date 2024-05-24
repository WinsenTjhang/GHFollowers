//
//  FollowersListViewModelTest.swift
//  GHFollowersTests
//
//  Created by winsen on 01/05/24.
//

import XCTest

@testable import GHFollowers

class FollowersListViewModelTests: XCTestCase {
    
    var viewModel: FollowersListViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var mockPersistenceManager: MockPersistenceManager!
    
    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        mockPersistenceManager = MockPersistenceManager()
        mockPersistenceManager.favorites = [Follower.sampleFollower]
        viewModel = FollowersListViewModel(networkManager: mockNetworkManager, persistenceManager: mockPersistenceManager)
        viewModel.user = Follower.sampleFollower
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistenceManager = nil
        mockNetworkManager = nil
    }
    
    func testFetchFollowersWithMoreFollowers_Success() async throws {
        mockNetworkManager.shouldGetFollowersSucceed = true
        mockNetworkManager.mockFollowers = try StaticJSONDecoder.decode(
            file: "UserFollowersStaticData", type: [Follower].self)
        mockNetworkManager.shouldSimulateHasMoreFollowers = true
        
        let expectation = XCTestExpectation(description: "Wait for fetchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        
        await viewModel.fetchFollowers()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        let staticData = try StaticJSONDecoder.decode(
            file: "UserFollowersStaticData", type: [Follower].self)
        
        defer {
            XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        }
        
        XCTAssertEqual(
            viewModel.followers, staticData, "The returned response should be decoded properly")
        XCTAssertTrue(
            viewModel.hasMoreFollowers, "The view model should indicate there are more followers")
        XCTAssertEqual(viewModel.currentPage, 2, "The view model current page index should be 2")
        
    }
    
    func testFetchFollowersWithoutMoreFollowers_Success() async throws {
        mockNetworkManager.shouldGetFollowersSucceed = true
        mockNetworkManager.mockFollowers = try StaticJSONDecoder.decode(
            file: "UserFollowersStaticData", type: [Follower].self)
        mockNetworkManager.shouldSimulateHasMoreFollowers = false
        
        let expectation = XCTestExpectation(description: "Wait for fetchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        
        await viewModel.fetchFollowers()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        let staticData = try StaticJSONDecoder.decode(
            file: "UserFollowersStaticData", type: [Follower].self)
        
        defer {
            XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        }
        
        XCTAssertEqual(
            viewModel.followers, staticData, "The returned response should be decoded properly")
        XCTAssertFalse(
            viewModel.hasMoreFollowers, "The view model should indicate there are more followers")
        XCTAssertEqual(viewModel.currentPage, 1, "The view model current page index should be 1")
        
    }
    
    func testFetchFollowers_Failed() async throws {
        mockNetworkManager.shouldGetFollowersSucceed = false
        let expectation = XCTestExpectation(description: "Wait for fetchFollowers to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        
        await viewModel.fetchFollowers()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        defer {
            XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        }
        
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
        
    }
    
    func testGetUserInfo_Success() async throws {
        mockNetworkManager.shouldGetUserInfoSucceed = true
        let expectedUser = User.sampleUser
        let expectedUserInfo = Follower(login: expectedUser.login, avatarUrl: expectedUser.avatarUrl)
        
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        
        let userInfo = await viewModel.getUserInfo()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(userInfo, expectedUserInfo, "The returned user should match the expected user")
        XCTAssertFalse(viewModel.showErrorAlert, "The view model should not show an error alert")
        XCTAssertEqual(viewModel.errorMessage, "", "The view model error message should be empty")
    }
    
    func testGetUserInfo_Failed() async throws {
        mockNetworkManager.shouldGetUserInfoSucceed = false
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        
        let userInfo = await viewModel.getUserInfo()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        defer {
            XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading any data")
        }
        
        XCTAssertNil(userInfo, "The returned user info should be nil")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
    func testAddToFavorite_Success() {
        mockPersistenceManager.shouldAddSucceed = true
        viewModel.addToFavorite()
        
        XCTAssertTrue(mockPersistenceManager.addWasCalled, "The persistence manager's add method should be called")
        XCTAssertFalse(viewModel.showErrorAlert, "The view model should not show an error alert")
        XCTAssertEqual(viewModel.errorMessage, "", "The view model error message should be empty")
    }
    
    func testAddToFavorite_Failure() {
        mockPersistenceManager.shouldAddSucceed = false
        viewModel.addToFavorite()
        
        XCTAssertTrue(mockPersistenceManager.addWasCalled, "The persistence manager's add method should be called")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
    func testRemoveFavorite_Success() {
        defer {
            mockPersistenceManager.removeWasCalled = false
        }
        
        mockPersistenceManager.shouldRemoveSucceed = true
        viewModel.removeFavorite()
        
        XCTAssertTrue(mockPersistenceManager.removeWasCalled, "The persistence manager's remove method should be called")
        XCTAssertEqual(mockPersistenceManager.favorites, [], "The favorites list should be empty")
        XCTAssertFalse(viewModel.showErrorAlert, "The view model should not show an error alert")
        XCTAssertEqual(viewModel.errorMessage, "", "The view model error message should be empty")
    }
    
    func testRemoveFavorite_Failure() {
        mockPersistenceManager.shouldRemoveSucceed = false
        viewModel.removeFavorite()
        
        XCTAssertTrue(mockPersistenceManager.removeWasCalled, "The persistence manager's remove method should be called")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
    func testIsUserFavorite_True() async {
        defer {
            mockPersistenceManager.retrieveWasCalled = false
        }
        
        mockPersistenceManager.shouldRetrieveSucceed = true
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.isUserFavorite()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertTrue(mockPersistenceManager.retrieveWasCalled, "The persistence manager's retrieve method should be called")
        XCTAssertTrue(viewModel.isOnFavorite, "The view model's isOnFavorite should be true")
        XCTAssertFalse(viewModel.showErrorAlert, "The view model should not show an error alert")
        XCTAssertEqual(viewModel.errorMessage, "", "The view model error message should be empty")
    }
    
    func testIsUserFavorite_False() async {
        mockPersistenceManager.shouldRetrieveSucceed = false
        
        let expectation = XCTestExpectation(description: "Wait for getUserInfo to complete")
        viewModel.completionHandler = {
            expectation.fulfill()
        }
        
        await viewModel.isUserFavorite()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertTrue(mockPersistenceManager.retrieveWasCalled, "The persistence manager's retrieve method should be called")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
    func testToggleFavoriteWhen_NotFavorite() {
        viewModel.isOnFavorite = false
        viewModel.toggleFavorite()
        
        XCTAssertTrue(viewModel.isOnFavorite, "isOnFavorite should be true after toggling")
        XCTAssertTrue(mockPersistenceManager.addWasCalled, "add() should be called on the persistence manager")
    }
    
    func testToggleFavoriteWhen_Favorite() {
        viewModel.isOnFavorite = true
        viewModel.toggleFavorite()
        
        XCTAssertFalse(viewModel.isOnFavorite, "isOnFavorite should be false after toggling")
        XCTAssertTrue(mockPersistenceManager.removeWasCalled, "remove() should be called on the persistence manager")
    }
    
}
