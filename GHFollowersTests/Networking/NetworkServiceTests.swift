//
//  NetworkServiceTests.swift
//  GHFollowersTests
//
//  Created by winsen on 12/04/24.
//

import XCTest
@testable import GHFollowers

class NetworkingManagerTests: XCTestCase {
    
    private var session: URLSession!
    private var followersEndPoint: URL!
    private var userInfoEndPoint: URL!
    
    override func setUp() {
        followersEndPoint = URL(string: "https://api.github.com/users/ovec8hkin/followers?per_page=20&page=1")
        userInfoEndPoint = URL(string: "https://api.github.com/users/ovec8hkin")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        followersEndPoint = nil
        userInfoEndPoint = nil
    }
    
    func testGetFollowers_Success() async throws {
        guard let path = Bundle.main.path(forResource: "UserFollowersStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        let statusCode = 200
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.followersEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let (responData, _) = try await NetworkManager.shared.getFollowers(session: session, of: "shipmadison", page: 1)
        let staticData = try StaticJSONDecoder.decode(file: "UserFollowersStaticData", type: [Follower].self)
        
        XCTAssertEqual(responData, staticData, "The returned response should be decoded properly")
    }
    
    func testGetFollowers_InvalidStatusCode_404() async {
        let statusCode = 404
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.followersEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkManager.shared.getFollowers(session: session, of: "ovec8hkin", page: 1)
            XCTFail("Should throw an error")
        } catch {
            guard let networkingError = error as? NetworkError else {
                XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                return
            }
            
            XCTAssertEqual(networkingError,
                           NetworkError.invalidStatusCode(statusCode: statusCode),
                           "Error should be a networking error which throws an invalid status code")
            
        }
    }
    
    func testPerformRequest_decodingFailed() async {
        let invalidData = "{'logyin': 'testuser', 'id': 'not-an-integer'}".data(using: .utf8)
        let statusCode = 200
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.followersEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, invalidData)
        }
        
        do {
            let data = try await NetworkManager.shared.getFollowers(session: session, of: "ovec8hkin", page: 1)
            XCTFail("Expected DecodingError to be thrown.")
        } catch {
            if !(error is DecodingError) {
                XCTFail("The error should be a system decoding error")
            }
        }
        
        
    }
    
    func testIfMorePagesAvailable_True() async throws {
        guard let path = Bundle.main.path(forResource: "UserFollowersStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        let statusCode = 200
        let header = ["Link" : "<https://api.github.com/user/9124240/followers?per_page=20&page=2>; rel=\"next\", <https://api.github.com/user/9124240/followers?per_page=20&page=2>; rel=\"last\""]
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.followersEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: header)
            return (response!, data)
        }
        
        let (_, hasMorePages)  = try await NetworkManager.shared.getFollowers(session: session, of: "ovec8hkin", page: 1)
        
        XCTAssertTrue(hasMorePages, "There should be more than 1 page")
        
    }
    
    func testIfMorePagesAvailable_False() async throws {
        guard let path = Bundle.main.path(forResource: "UserFollowersStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        let statusCode = 200
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.followersEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let (_, hasMorePages)  = try await NetworkManager.shared.getFollowers(session: session, of: "shipmadison", page: 1)
        
        XCTAssertFalse(hasMorePages, "There should be more no more pages")
        
    }
    
    func testGetUserInfo_Success() async throws {
        guard let path = Bundle.main.path(forResource: "UserInfoStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        let statusCode = 200
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.userInfoEndPoint,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let responData = try await NetworkManager.shared.getUserInfo(session: session, for: "ovec8hkin")
        let staticData = try StaticJSONDecoder.decode(file: "UserInfoStaticData", type: User.self)
        
        XCTAssertEqual(responData, staticData, "The returned response should be decoded properly")
    }
    
    func testDownloadImage_Success() async throws {
        guard let path = Bundle.main.path(forResource: "image", ofType: "jpeg"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        let statusCode = 200
        let avatarURL = "https://avatars.githubusercontent.com/u/9124240?v=4"
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: URL(string: avatarURL)!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let responData = try await NetworkManager.shared.downloadImage(session: session, urlString: avatarURL)
        let staticImage = UIImage(data: data)
        
        guard let imageData = staticImage!.pngData(),
              let downloadedImageData = responData.pngData() else {
            XCTFail("Failed to convert UIImage to PNG data")
            return
        }
        
        XCTAssertEqual(imageData, downloadedImageData, "The returned response should be the right image")
        
    }
    
    func testDownloadImage_Failed_InvalidImage() async throws {
        let statusCode = 200
        let avatarURL = "https://avatars.githubusercontent.com/u/9124240?v=4"
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: URL(string: avatarURL)!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        do {
            let data = try await NetworkManager.shared.downloadImage(session: session, urlString: avatarURL)
            XCTFail("Expected DecodingError to be thrown.")
        } catch {
            if !(error is DecodingError) {
                XCTFail("The error should be a system decoding error")
            }
        }
        
    }
    
}
