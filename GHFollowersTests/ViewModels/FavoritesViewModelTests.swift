//
//  FavoritesViewModelTests.swift
//  GHFollowersTests
//
//  Created by winsen on 21/05/24.
//

import XCTest

@testable import GHFollowers

class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    private var mockPersistenceManager: MockPersistenceManager!
    
    override func setUp() {
        mockPersistenceManager = MockPersistenceManager()
        viewModel = FavoritesViewModel(persistenceManager: mockPersistenceManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistenceManager = nil
    }
    
    func testRetrieveFavorites_Success() async throws {
        mockPersistenceManager.shouldRetrieveSucceed = true
        
        let expectedFavorites = [Follower.sampleFollower]
        mockPersistenceManager.favorites = expectedFavorites
        
        viewModel.retrieveFavorites()
        
        XCTAssertTrue(mockPersistenceManager.retrieveWasCalled, "The persistence manager's retrieve method should be called")
        XCTAssertEqual(viewModel.favorites, expectedFavorites, "The favorites property should be updated with the favorites from the persistence manager")
    }
    
    func testRetrieveFavorites_Failed() async throws {
        mockPersistenceManager.shouldRetrieveSucceed = false
        viewModel.retrieveFavorites()
        
        XCTAssertTrue(mockPersistenceManager.retrieveWasCalled, "The persistence manager's retrieve method should be called")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
    func testRemoveFavorites_Success() async throws {
        mockPersistenceManager.shouldRemoveSucceed = true
        mockPersistenceManager.favorites = [Follower.sampleFollower]
        
        viewModel.remove(index: IndexSet(integer: 0))
        
        XCTAssertTrue(mockPersistenceManager.removeWasCalled, "The persistence manager's remove method should be called")
        XCTAssertEqual(viewModel.favorites, [], "The favorites property should be empty")
    }
    
    func testRemoveFavorites_Failed() async throws {
        mockPersistenceManager.shouldRemoveSucceed = false
        viewModel.remove(index: IndexSet(integer: 0))
        
        XCTAssertTrue(mockPersistenceManager.removeWasCalled, "The persistence manager's remove method should be called")
        XCTAssertTrue(viewModel.showErrorAlert, "The view model should show an error alert")
        XCTAssertNotNil(viewModel.errorMessage, "The view model error should be set")
    }
    
}
