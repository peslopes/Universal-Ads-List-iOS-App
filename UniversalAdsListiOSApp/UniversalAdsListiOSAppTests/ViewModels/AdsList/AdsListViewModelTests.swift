import XCTest
import Combine
@testable import UniversalAdsListiOSApp

final class AdsListViewModelTests: XCTestCase {
    
    func testFetchAds_Success() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.count == 4 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.count, 4)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchAds_Failure() {
        let mockAPIservice = MockAPIService()
        mockAPIservice.shouldFail = true
        let sut = AdsListViewModel(apiService: mockAPIservice)
        let expectation = XCTestExpectation()
        let cancellable = sut.$errorMessage
            .sink { message in
                if message != nil {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertTrue(sut.filteredAds.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchCategories_Success() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchCategories()
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.categories.count, 2)
    }
    
    func testSearchTextFilter() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.count == 1 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.searchText = "B"
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.count, 1)
        XCTAssertEqual(sut.filteredAds.first?.title, "B")
    }
    
    func testUrgentOnlyFilter() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.count == 1 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.isUrgentOnly = true
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.count, 1)
        XCTAssertTrue(sut.filteredAds.first?.isUrgent ?? false)
        
    }
    
    func testSortOrder_AlphebeticalAscending() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.first?.title == "A", ads.last?.title == "D"{
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.sortOrder = .alphabeticalAscending
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.first?.title, "A")
        XCTAssertEqual(sut.filteredAds.last?.title, "D")
    }
    
    func testSortOrder_AlphebeticalDescending() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.first?.title == "D", ads.last?.title == "A" {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.sortOrder = .alphabeticalDescending
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.first?.title, "D")
        XCTAssertEqual(sut.filteredAds.last?.title, "A")
    }
    
    func testSortOrder_PriceAscending() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.first?.price == 10, ads.last?.price == 25 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.sortOrder = .priceAscending
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.first?.price, 10)
        XCTAssertEqual(sut.filteredAds.last?.price, 25)
    }
    
    func testSortOrder_PriceDescending() {
        let sut = AdsListViewModel(apiService: MockAPIService())
        let expectation = XCTestExpectation()
        let cancellable = sut.$filteredAds
            .sink { ads in
                if ads.first?.price == 25, ads.last?.price == 10 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchAds()
        sut.sortOrder = .priceDescending
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.filteredAds.first?.price, 25)
        XCTAssertEqual(sut.filteredAds.last?.price, 10)
    }
}
