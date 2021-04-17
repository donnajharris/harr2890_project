//
//  CategoryHelper_Tests.swift
//  harr2890_projectTests
//
//  Created by Donna Harris on 2021-04-14.
//

import XCTest
@testable import harr2890_project

class CategoryHelper_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func test_categoryNameIsValid_isNotBlank_returnsTrue() {
        // arrange
        let expectedResult = true
        let categoryName = "Not Blank"
        
        let helper = CategoryHelper()
        
        // act
        let actualResult = helper.categoryNameIsValid(categoryName: categoryName)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
        
    }
    
    
    func test_categoryNameIsValid_isBlank_returnsFalse() {
        // arrange
        let expectedResult = false
        let categoryName = ""
        
        let helper = CategoryHelper()
        
        // act
        let actualResult = helper.categoryNameIsValid(categoryName: categoryName)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
    }
    

    func test_categoryAlreadyExists_returnsFalse() {
        
        // arrange
        var categories = [ItemCategory]()
        categories.append(ItemCategory(id: Int64(3), name: "First Category"))
        categories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        categories.append(ItemCategory(id: Int64(2), name: "Third Category"))

        let categoryToTest = ItemCategory(name: "Fourth Category") // not in list

        let expectedResult = false
        
        let helper = CategoryHelper()
        
        // act
        let actualResult = helper.categoryAlreadyExists(category: categoryToTest, categories: categories)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
        
    }
    
    
    func test_categoryAlreadyExists_returnsTrue() {
        
        // arrange
        var categories = [ItemCategory]()
        categories.append(ItemCategory(id: Int64(3), name: "First Category"))
        categories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        categories.append(ItemCategory(id: Int64(2), name: "Third Category"))

        let categoryToTest = ItemCategory(name: "First Category") // already in list

        let expectedResult = true
        
        let helper = CategoryHelper()
        
        // act
        let actualResult = helper.categoryAlreadyExists(category: categoryToTest, categories: categories)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
    }

    func test_categoryHasBeenChanged_notChanged_returnsFalse() {
        let expectedResult = false
        var actualResult : Bool
        
        let originalCategoryName = "Unedited Category"
        let expectedCategoryName = "Unedited Category"

        let category = ItemCategory(id: Int64(4), name: expectedCategoryName)
        
        let helper = CategoryHelper()
        
        // act
        actualResult = helper.categoryHasBeenChanged(category: category, newName: originalCategoryName)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
    func test_categoryHasBeenChanged_wasChanged_returnsTrue() {
        let expectedResult = true
        var actualResult : Bool
        
        let originalCategoryName = "Original Category"
        let expectedCategoryName = "Changed Category"

        let category = ItemCategory(id: Int64(4), name: expectedCategoryName)
        
        let helper = CategoryHelper()
        
        // act
        actualResult = helper.categoryHasBeenChanged(category: category, newName: originalCategoryName)
        
        // assert
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
//
//    func test_categoryHasBeenChanged_notChanged_returnsFalse() {
//        // arrange
//        var categories = [ItemCategory]()
//        categories.append(ItemCategory(id: Int64(3), name: "First Category"))
//        categories.append(ItemCategory(id: Int64(1), name: "Second Category"))
//        categories.append(ItemCategory(id: Int64(2), name: "Third Category"))
//
//        let updatedCategory = ItemCategory(id: Int64(3), name: "First Category") // already in list but unchanged
//
//        let expectedResult = false
//
//        let helper = CategoryHelper()
//
//        // act
//        let actualResult = try! helper.categoryHasBeenChanged(category: updatedCategory, categories: categories)
//
//        // assert
//        XCTAssertEqual(expectedResult, actualResult)
//    }
//
//
//    func test_categoryHasBeenChanged_wasUpdated_returnsTrue() {
//        // arrange
//        var categories = [ItemCategory]()
//        categories.append(ItemCategory(id: Int64(3), name: "First Category"))
//        categories.append(ItemCategory(id: Int64(1), name: "Second Category"))
//        categories.append(ItemCategory(id: Int64(2), name: "Third Category"))
//
//        let updatedCategory = ItemCategory(id: Int64(3), name: "Edited Category") // already in list and changed
//
//        let expectedResult = true
//
//        let helper = CategoryHelper()
//
//        // act
//        let actualResult = try! helper.categoryHasBeenChanged(category: updatedCategory, categories: categories)
//
//        // assert
//        XCTAssertEqual(expectedResult, actualResult)
//    }
//
//    func test_categoryHasBeenChanged_indexNil_throwsInvalidUsageError() {
//        // arrange
//        var categories = [ItemCategory]()
//        categories.append(ItemCategory(id: Int64(3), name: "First Category"))
//        categories.append(ItemCategory(id: Int64(1), name: "Second Category"))
//        categories.append(ItemCategory(id: Int64(2), name: "Third Category"))
//
//        let updatedCategory = ItemCategory(name: "First Category") // named, but without Id, showing bad usage
//
//        let helper = CategoryHelper()
//
//        // act & assert
//        XCTAssertThrowsError(try helper.categoryHasBeenChanged(category: updatedCategory, categories: categories)) {
//            error in XCTAssertEqual(error as! CategoryHelper.CategoryHelperError, CategoryHelper.CategoryHelperError.invalidUsage)
//        }
//    }
}
