//
//  MarvelCharacters_iOSAppTests.swift
//  MarvelCharacters-iOSAppTests
//
//  Created by Sergio Martínez Muñoz on 25/7/21.
//

import XCTest
@testable import MarvelCharacters_iOSApp

class MarvelCharacters_iOSAppTests: XCTestCase {

    var sut: CharactersListPresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = CharactersListPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // Test that a request is not made to fetch more characters when there are still enough characters left in the current list (10 or more)
    func testNoRequestWhenEnoughCellsRemaining() throws {
        // given - 20 characters loaded, no request in progress
        sut.characterList = []
        sut.requestInProgress = false
        for i in 1...20 {
            sut.characterList?.append(CharacterListModel(name: "Test", id: i, thumbnail: ("Test","Test")))
        }

        // when - the tableView IndexPath.row is now 10
        sut.updateMaxIndex(index: 10)

        // then - a request is not in progress
        XCTAssertTrue(sut.requestInProgress != true, "Test failed - CharacterListPresenter launched the request for more characters")
    }

    // Test that a request to fetch more characters is made when the user is scrolling close to the end of the list of current characters (less than 10)
    func testRequestMoreCharactersWhenUserIsCloseToListsEnd() throws {
        // given - 20 characters loaded, no request in progress
        sut.characterList = []
        sut.requestInProgress = false
        for i in 1...20 {
            sut.characterList?.append(CharacterListModel(name: "Test", id: i, thumbnail: ("Test","Test")))
        }

        // when - the tableView IndexPath.row is now 11
        sut.updateMaxIndex(index: 12)

        // then - a request is not in progress
        XCTAssertTrue(sut.requestInProgress == true, "Test failed - CharacterListPresenter is not fetching more characters")
    }

    // Test that a new request for a new character list is made when the presenter is informed that the text in the search bar has changed
    func testNewRequestWhenTextChanged() throws {
        //given: no request in progress, different text in the search bar (Timer's userInfo) than the last successful request, timer configured with new text
        sut.requestInProgress = false
        sut.lastTextRequested = "Text1"
        sut.searchBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sut.performSearchTextChanged), userInfo: "Text2", repeats: false)

        //when - method that fires on timer completion
        sut.performSearchTextChanged()

        //then - request in progress, with offset 0 (from the beginnning of the new list)
        XCTAssertTrue(sut.offsetRequested == 0, "Test failed - CharacterListPresenter is not requesting from the beginning of the new list")
        XCTAssertTrue(sut.requestInProgress == true, "Test failed - CharacterListPresenter is not fetching new characters")
    }

    // Test that the control parameters used by the presenter are updated after a successful request
    func testUpdateRequestParametersOnNewSuccessfulSearch() throws {
        //given: old values for text requested, offset, api message and character query
        sut.lastTextRequested = "old query"
        sut.offsetRequested = 60
        sut.apiMessage = "old message"
        sut.characterList = [CharacterListModel]()
        sut.characterList?.append(CharacterListModel(name: "First character", id: 99999, thumbnail: ("Test","Test")))

        //when: a new character list is received successfully
        var newCharacterListModel = [CharacterListModel]()
        for i in 1...20 {
            newCharacterListModel.append(CharacterListModel(name: "Test", id: i, thumbnail: ("Test","Test")))
        }
        sut.getCharacterListSuccess(characterList: newCharacterListModel, offset: 0, name: "New Query", apiMessage: "api message")

        //then: values for search query, offset, api message and character list are updted
        XCTAssertTrue(sut.characterList?.count == newCharacterListModel.count, "Test failed - Character array not updated correctly - Different number of items")
        XCTAssertTrue(sut.offsetRequested == 0, "Test failed - Offset not updated correctly")
        XCTAssertTrue(sut.apiMessage == "api message", "Test failed - API message not updated correctly")
        XCTAssertTrue(sut.lastTextRequested == "New Query", "Test failed - Search query not updated correctly")
    }

}


