//
//  Structs.swift
//
//
//  Created by Tohr01 on 13.04.22.
//

import Foundation

public struct button {
    public var name: String
    public var audio_url: URL
    
    public init(name: String, audio_url: URL) {
        self.name = name 
        self.audio_url = audio_url
    }
}
