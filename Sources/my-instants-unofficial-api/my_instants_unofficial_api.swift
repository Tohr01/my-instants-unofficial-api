//
//  my_instants_unofficial_api.swift
//
//
//  Created by Tohr01 on 13.04.22.
//

import Foundation

public struct MyInstants {
    let parser: Parser

    public init() {
        parser = Parser()
    }

    /**
     Prints the last available page for a given search query

     Can be used im combination with @see search(_ search_query: String, page: Int = 1)

     - Parameter search_query: The search query
     - Throws: Throws error when: HTML cannot be requested, HTML cannot be parsed correctly

     - Returns: The last available page as and integer or nil
     */
    public func get_available_pages(_ search_query: String) async throws -> Int? {
        do {
            return try await parser.get_available_pages(for: search_query)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /**
     Returns Array of buttons parsed from a search query

     - Parameter url: The URL
     - Parameter page: Specify the page @see get_available_pages(for search_query: String)

     - Throws: Throws error when: HTML cannot be requested, HTML cannot be parsed correctly

     - Returns: Array of buttons or nil
     */
    public func search(_ search_query: String, page: Int = 1) async throws -> [button]? {
        if let url = URL(string: "https://www.myinstants.com/search/?name=\(search_query)") {
            do {
                let buttons = try await parser.get_buttons(from: url, page: page)

                return buttons
            } catch {
                print(error.localizedDescription)
                return nil
            }

        } else {
            return nil
        }
    }
}
