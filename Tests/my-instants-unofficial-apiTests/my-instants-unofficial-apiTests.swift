//
//  File.swift
//  my-instants-unofficial-api
//
//  Created by Tohr01 on 13.04.22.
//

@testable import my_instants_unofficial_api
import XCTest

final class my_instants_unofficial_apiTests: XCTestCase {
    func test_available_pages() async throws {
        let my_instants = MyInstants()

        do {
            let pages = try await my_instants.get_available_pages("test")

            guard let pages = pages else {
                return
            }
            // Testing
            XCTAssertEqual(pages, 15)
        } catch {
            print(error.localizedDescription)
        }
    }

    func test_button_parsing() async throws {
        let my_instants = MyInstants()
        do {
            let buttons = try await my_instants.search("test")

            guard let buttons = buttons else {
                return
            }
            print(buttons.count)
            // Testing
            XCTAssertEqual(buttons.count, 27)
        } catch {
            print(error.localizedDescription)
        }
    }

    func test_button_pages() async throws {
        let my_instants = MyInstants()
        do {
            let buttons = try await my_instants.search("test", page: 2)

            guard let buttons = buttons else {
                return
            }

            // Testing
            XCTAssertEqual(buttons.count, 27)
        } catch {
            print(error.localizedDescription)
        }
    }
}
