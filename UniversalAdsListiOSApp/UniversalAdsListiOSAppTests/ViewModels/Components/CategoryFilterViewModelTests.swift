import XCTest
import Combine
@testable import UniversalAdsListiOSApp

final class CategoryFilterViewModelTests: XCTestCase {
    
    func testSelectAll() {
        let publisher = Just([
            CategoryModel(id: 1, name: "category1"),
            CategoryModel(id: 2, name: "category2")
        ]).eraseToAnyPublisher()
                             
        let sut = CategoryFilterMenuViewModel(categoriesPublisher: publisher, filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        sut.selectAll()
        
        XCTAssertEqual(sut.selectedCategories.count, 2)
    }
    
    func testUnselectAll() {
        let publisher = Just([
            CategoryModel(id: 1, name: "category1"),
            CategoryModel(id: 2, name: "category2")
        ]).eraseToAnyPublisher()
                             
        let sut = CategoryFilterMenuViewModel(categoriesPublisher: publisher, filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        sut.selectAll()
        
        XCTAssertEqual(sut.selectedCategories.count, 2)
        
        sut.unselectAll()
        
        XCTAssertTrue(sut.selectedCategories.isEmpty)
    }
    
    func testToggleCategorySelection() {
        let publisher = Just([
            CategoryModel(id: 1, name: "category1"),
            CategoryModel(id: 2, name: "category2")
        ]).eraseToAnyPublisher()
                             
        let sut = CategoryFilterMenuViewModel(categoriesPublisher: publisher, filterHandler: FilterHandler())
        let expectation = XCTestExpectation()
        let cancellable = sut.$categories
            .sink { categories in
                if categories.count == 2 {
                    expectation.fulfill()
                }
            }
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        sut.toggleCategorySelection(CategoryModel(id: 1, name: "category1"))
        
        XCTAssertEqual(sut.selectedCategories.first?.id, 1)
        
        sut.toggleCategorySelection(CategoryModel(id: 1, name: "category1"))
        
        XCTAssertTrue(sut.selectedCategories.isEmpty)
        
    }
}
