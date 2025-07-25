//
//  MovieExplorerTaskTests.swift
//  MovieExplorerTaskTests
//
//  Created by Apple on 24/07/25.
//

import XCTest
@testable import MovieExplorer

final class MovieDetailViewModelTests: XCTestCase {

    var viewModel: MovieDetailViewModel!
    var mockService: MockServiceManager!

    override func setUp() {
        super.setUp()
        mockService = MockServiceManager()
        viewModel = MovieDetailViewModel(movieID: 123, service: mockService)
    }

    func testFetchMovieDetailSuccess() {
        let expectation = self.expectation(description: "Detail fetched")

        mockService.mockDetailResult = .success(MovieDetail(id: 123, title: "Inception", overview: "Dreams", releaseDate: "2010", voteAverage: 8.7, genres: []))

        viewModel.onUpdate = {
            XCTAssertEqual(self.viewModel.movie?.title, "Inception")
            expectation.fulfill()
        }

        viewModel.fetchDetails()

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchMovieDetailFailure() {
        let expectation = self.expectation(description: "Fetch failed")

        mockService.mockDetailResult = .failure(NSError(domain: "TestError", code: 400, userInfo: nil))

        viewModel.onError = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        viewModel.fetchDetails()

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchTrailerReturnsURL() {
        let expectation = self.expectation(description: "Trailer fetched")

        mockService.mockVideos = [
            MovieVideo(key: "abc123", name: "Official Trailer", site: "YouTube", type: "Trailer")
        ]

        viewModel.fetchTrailer { url in
            XCTAssertEqual(url?.absoluteString, "https://www.youtube.com/watch?v=abc123")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchTrailerEmpty() {
        let expectation = self.expectation(description: "No trailer found")

        mockService.mockVideos = [] // empty list

        viewModel.fetchTrailer { url in
            XCTAssertNil(url)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}

class MockServiceManager: ServiceProtocol {

    var mockDetailResult: Result<MovieDetail, Error>?
    var mockVideos: [MovieVideo]?

    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        if let result = mockDetailResult {
            completion(result)
        }
    }

    func fetchVideos(for movieID: Int, completion: @escaping (Result<[MovieVideo], Error>) -> Void) {
        if let videos = mockVideos {
            completion(.success(videos))
        } else {
            completion(.success([]))
        }
    }
}
