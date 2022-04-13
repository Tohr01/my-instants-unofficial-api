//
//  Extentions.swift
//
//
//  Created by Tohr01 on 13.04.22.
//

import Foundation

@available(macOS, deprecated: 12.0, message: "Using replacment bridge instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, err in
                guard let data = data, let response = response else {
                    let err = err ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: err)
                }

                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}
