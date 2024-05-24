//
//  MockPersistenceManager.swift
//  GHFollowersTests
//
//  Created by winsen on 13/05/24.
//

import SwiftUI
@testable import GHFollowers

class MockPersistenceManager: PersistenceManagerProtocol {
    var favorites: [Follower] = []
    var userData: [Follower]?
    
    var shouldAddSucceed = true
    var shouldRemoveSucceed = true
    var shouldRetrieveSucceed = true
    var shouldSaveSucceed = true

    var addWasCalled = false
    var removeWasCalled = false
    var retrieveWasCalled = false
    var saveWasCalled = false

    func add(favorite: Follower) throws {
        addWasCalled = true
        if !shouldAddSucceed {
            throw PersistenceError.alreadyInFavorites
        }
        
    }
    
    func remove(indexSet: IndexSet) throws {
        removeWasCalled = true
        favorites.remove(atOffsets: indexSet)
        if !shouldRemoveSucceed {
            throw PersistenceError.unableToFavorite
        }
        
    }
    
    func retrieveFavorites() throws {
        retrieveWasCalled = true
        if !shouldRetrieveSucceed {
            throw PersistenceError.unableToRetrieve
        }
       
    }
    
    func saveFavorites() throws {
        saveWasCalled = true
        if !shouldSaveSucceed {
            throw PersistenceError.unableToFavorite
        }
       
    }
}
