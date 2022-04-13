//
//  Parser.swift
//
//
//  Created by Tohr01 on 13.04.22.
//

import Foundation
import SwiftSoup

class Parser {
    init() {}

    /**
     Asynchronously gets html source code from given URL

     - Parameter url: The url
     - Throws: Throws error when: HTML cannot be requested

     - Returns: The HTML as a String; If an error occurs result may be nil or the function may throw an error
     */
    private func get_html(from url: URL) async throws -> String? {
        let (data, _) = try await URLSession.shared.data(from: url)
        let html_string: String? = String(data: data, encoding: .utf8)
        return html_string
    }

    /**
     Returns Array of buttons parsed from a given URL

     - Parameter url: The URL
     - Parameter page: Specify the page @see get_available_pages(for search_query: String)

     - Throws: Throws error when: HTML cannot be requested, HTML cannot be parsed correctly

     - Returns: Array of buttons (type button) or nil
     */
    func get_buttons(from url: URL, page: Int = 1) async throws -> [button]? {
        let url_string: String = url.absoluteString.appending("?page\(page)")
        let new_url = URL(string: url_string)!
        do {
            // Get html from url
            let html: String? = try await get_html(from: new_url)
            guard let html = html else {
                return nil
            }

            var buttons: [button]?
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let body: Element? = doc.body()
                if nothing_found(html) {
                    return nil
                }
                let elements: Elements? = try body?.getElementsByClass("instant")
                if let elem_arr = elements?.array() {
                    buttons = []
                    for elem in elem_arr {
                        let audio_raw = try elem.getElementsByClass("small-button").attr("onmousedown")
                        let title = try elem.select("a").text()

                        if !audio_raw.isEmpty, !title.isEmpty {
                            // Slice extracted audio url from play'([url])' -> [url]
                            let start = audio_raw.index(audio_raw.startIndex, offsetBy: 6)
                            let end = audio_raw.index(audio_raw.endIndex, offsetBy: -3)
                            let audio_path = audio_raw[start ..< end]

                            buttons?.append(button(name: title, audio_url: URL(string: "https://www.myinstants.com")!.appendingPathComponent(String(audio_path))))
                        }
                    }
                }
                return buttons
            } catch {
                // Print error and return nil
                print(error.localizedDescription)
                return nil
            }
        }
    }

    /**
     Prints the last available page for a given search query

     Can be used im combination with @see get_buttons(from url: URL, page: Int = 1)

     - Parameter search_query: The search query
     - Throws: Throws error when: HTML cannot be requested, HTML cannot be parsed correctly

     - Returns: The last available page as and integer or nil
     */
    func get_available_pages(for search_query: String) async throws -> Int? {
        guard let url = URL(string: "https://www.myinstants.com/search/?name=\(search_query)") else {
            return nil
        }
        do {
            guard let html = try await get_html(from: url) else {
                return nil
            }
            if nothing_found(html) {
                return nil
            }
            let doc: Document = try SwiftSoup.parse(html)
            let body: Element? = doc.body()
            if let pages = try body?.getElementsByClass("pagination").select("li").select(".hide-on-small-only") {
                let pages_arr = pages.array()
                return Int(try pages_arr[pages_arr.endIndex - 1].text())
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    /**
     Check if the given html contains instant buttons or if no buttons are found

     - Parameter html: The html

     - Returns: Returns false if no buttons are found
     */
    private func nothing_found(_ html: String) -> Bool {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let body: Element? = doc.body()
            if let paragraphs = try body?.select("h2").text(), paragraphs.contains("No results for") {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return true
        }
        return false
    }
}
