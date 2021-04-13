//
//  Category_CRUD_Tests.swift
//  harr2890_projectTests
//
//  Created by Donna Harris on 2021-04-12.
//

import XCTest
@testable import harr2890_project

class Category_CRUD_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_getAllCategories_returnsAllCategories() throws {
        
        // arrange
        var actualCategories = [ItemCategory]()  // start empty

        var expectedCategories = [ItemCategory]()
        expectedCategories.append(ItemCategory(id: Int64(3), name: "First Category"))
        expectedCategories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        expectedCategories.append(ItemCategory(id: Int64(2), name: "Third Category"))

        let db = MockedDatabaseAccess()
        let categoryHandler = CategoryHandler(dal: db)

        // act
        try categoryHandler.getCategoriesFromDB(tableData: &actualCategories)

        // assert
        XCTAssertEqual(actualCategories, expectedCategories)
    }
    
    //insertCategory(category: ItemCategory) -> Int64
    func test_insertCategory_returnsUpdatedCategoryList() throws {
        // arrange
        var actualCategories = [ItemCategory]()
        actualCategories.append(ItemCategory(id: Int64(3), name: "First Category"))
        actualCategories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        actualCategories.append(ItemCategory(id: Int64(2), name: "Third Category"))
        // Id hasn't been set when first adding
        //let categoryToAdd = ItemCategory(id: ItemCategory.UNDEFINED, name: "NEW Category")
        let categoryToAdd = ItemCategory(name: "NEW Category")

        var expectedCategories = [ItemCategory]()
        expectedCategories.append(ItemCategory(id: Int64(3), name: "First Category"))
        expectedCategories.append(ItemCategory(id: Int64(4), name: "NEW Category"))
        expectedCategories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        expectedCategories.append(ItemCategory(id: Int64(2), name: "Third Category"))
        
        let db = MockedDatabaseAccess()
        let categoryHandler = CategoryHandler(dal: db)

        // act
        try categoryHandler.addCategoryToDB(category: categoryToAdd, tableData: &actualCategories)

        // assert
        XCTAssertEqual(actualCategories, expectedCategories)
    }
    
    
    func test_removeCategory_returnsUpdatedCategoryList() throws {
        
        // arrange
        var actualCategories = [ItemCategory]()
        actualCategories.append(ItemCategory(id: Int64(3), name: "First Category"))
        actualCategories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        actualCategories.append(ItemCategory(id: Int64(4), name: "Test to REMOVE Category"))
        actualCategories.append(ItemCategory(id: Int64(2), name: "Third Category"))

        let actualIndex = 2  // third item in the table list (index 2)
        let categoryToRemove = ItemCategory(id: Int64(4), name: "Test to REMOVE Category")

        var expectedCategories = [ItemCategory]()
        expectedCategories.append(ItemCategory(id: Int64(3), name: "First Category"))
        expectedCategories.append(ItemCategory(id: Int64(1), name: "Second Category"))
        expectedCategories.append(ItemCategory(id: Int64(2), name: "Third Category"))
        
        let db = MockedDatabaseAccess()
        let categoryHandler = CategoryHandler(dal: db)

        // act
        try categoryHandler.removeCategoryFromDB(indexToDelete: actualIndex, category: categoryToRemove, tableData: &actualCategories)

        // assert
        XCTAssertEqual(actualCategories, expectedCategories)
    }

}
