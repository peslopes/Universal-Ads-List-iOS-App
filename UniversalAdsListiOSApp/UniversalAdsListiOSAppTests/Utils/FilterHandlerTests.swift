import XCTest
@testable import UniversalAdsListiOSApp

final class FilterHandlerTests: XCTestCase {
    
    func testAddFilter() {
        let sut = FilterHandler()
        let filter = AdFilter(id: "filter") { $0.isUrgent }
        
        var expectedFilters = Set<AdFilter>()
        let expectation = XCTestExpectation()
        
        let cancellable = sut.filterPublisher
            .sink { filters in
                if filters.contains(filter) {
                    expectedFilters = filters
                    expectation.fulfill()
                }
            }
    
        sut.addFilter(filter)
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(expectedFilters.contains(filter))
    }
    
    func testRemoveFilter() {
        let sut = FilterHandler()
        let filter1 = AdFilter(id: "filter1") { $0.isUrgent }
        let filter2 = AdFilter(id: "filter2") { $0.title.contains("Test") }
        sut.addFilter(filter1)
        sut.addFilter(filter2)
        
        var expectedFilters = Set<AdFilter>()
        let expectation = XCTestExpectation()
        
        let cancellable = sut.filterPublisher
            .sink { filters in
                if !filters.contains(filter1) && filters.contains(filter2) {
                    expectedFilters = filters
                    expectation.fulfill()
                }
            }
        
        sut.removeFilter(withId: "filter1")
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertFalse(expectedFilters.contains(filter1))
        XCTAssertTrue(expectedFilters.contains(filter2))
    }
    
    func testClearAllFilters() {
        let sut = FilterHandler()
        let filter1 = AdFilter(id: "filter1") { $0.isUrgent }
        let filter2 = AdFilter(id: "filter2") { $0.title.contains("Test") }
        sut.addFilter(filter1)
        sut.addFilter(filter2)
        
        var expectedFilters: Set<AdFilter> = [filter1, filter2]
        let expectation = XCTestExpectation()
        
        let cancellable = sut.filterPublisher
            .sink { filters in
                if filters.isEmpty {
                    expectedFilters = filters
                    expectation.fulfill()
                }
            }
        
        sut.clearAllFilters()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(expectedFilters.isEmpty)
    }
}
