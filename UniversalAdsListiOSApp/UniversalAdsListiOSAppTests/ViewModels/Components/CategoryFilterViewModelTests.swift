import XCTest
import Combine
@testable import UniversalAdsListiOSApp

final class CategoryFilterViewModelTests: XCTestCase {
    
    func testFetchCategories_Success() {
        let sut = CategoryFilterMenuViewModel(apiService: MockAPIService(), filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchCategories()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.categories.count, 2)
    }
    
    func testSelectAll() {
        let sut = CategoryFilterMenuViewModel(apiService: MockAPIService(), filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchCategories()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        sut.selectAll()
        
        XCTAssertEqual(sut.selectedCategories.count, 2)
    }
    
    func testUnselectAll() {
        let sut = CategoryFilterMenuViewModel(apiService: MockAPIService(), filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchCategories()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        sut.selectAll()
        
        XCTAssertEqual(sut.selectedCategories.count, 2)
        
        sut.unselectAll()
        
        XCTAssertTrue(sut.selectedCategories.isEmpty)
    }
    
    func testToggleCategorySelection() {
        let sut = CategoryFilterMenuViewModel(apiService: MockAPIService(), filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.fetchCategories()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        sut.toggleCategorySelection(CategoryModel(id: 1, name: "category1"))
        
        XCTAssertEqual(sut.selectedCategories.first?.id, 1)
        
        sut.toggleCategorySelection(CategoryModel(id: 1, name: "category1"))
        
        XCTAssertTrue(sut.selectedCategories.isEmpty)
        
    }
}
