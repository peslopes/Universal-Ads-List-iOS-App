import XCTest
import Combine
@testable import UniversalAdsListiOSApp

final class AdDetailsViewModelTests: XCTestCase {
    
    func testFetchImage_Success() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        let expectation = XCTestExpectation()
        let sut = AdDetailsViewModel(ad: ad, category: "test", imageLoader: MockImageLoader())
        let cancellable = sut.$image
            .sink { image in
                if image != nil {
                    expectation.fulfill()
                }
            }
        
        sut.fetchImage()
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertNotNil(sut.image)
    }
    
    func testFetchImage_Failure() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        let expectation = XCTestExpectation()
        
        let imageLoader = MockImageLoader()
        imageLoader.shouldFailure = true
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category", imageLoader: imageLoader)
        let cancellable = sut.$image
            .sink { image in
                if image == UIImage(systemName: "photo") {
                    expectation.fulfill()
                }
            }
        
        sut.fetchImage()
        
        wait(for: [expectation], timeout: 2.0)
        cancellable.cancel()
        
        XCTAssertEqual(sut.image, UIImage(systemName: "photo"))
    }
    
    func testTitleProperty() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category")
        
        XCTAssertEqual(sut.title, "Test Ad")
    }
    
    func testPriceProperty() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category")
        
        XCTAssertEqual(sut.price, "100€")
    }
    
    func testDescriptionProperty() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category")
        
        XCTAssertEqual(sut.description, "Description test")
    }
    
    func testCategoryProperty() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category")
        
        XCTAssertEqual(sut.category, "Test Category")
    }
    
    func testIsUrgentProperty() {
        let ad = AdModel(
            id: 1,
            title: "Test Ad",
            description: "Description test",
            price: 100,
            categoryID: 1,
            imagesURL: ImagesURL(small: nil, thumb: nil),
            isUrgent: true
        )
        
        let sut = AdDetailsViewModel(ad: ad, category: "Test Category")
        
        XCTAssertTrue(sut.isUrgent)
    }
}
