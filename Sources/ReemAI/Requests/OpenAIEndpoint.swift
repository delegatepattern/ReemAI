//
//  OpenAIEndpoint.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation

public struct OpenAIEndpoint {
    public static let baseURL = URL(string: "https://api.openai.com")!

    public static var completionsURL: URL {
        baseURL.appendingPathComponent("/v1/completions")
    }

    public static var chatURL: URL {
        baseURL.appendingPathComponent("/v1/chat/completions")
    }

    public static var editsURL: URL {
        baseURL.appendingPathComponent("v1/edits")
    }

    public static var imageGenerateURL: URL {
        baseURL.appendingPathComponent("v1/images/generations")
    }

    public static var transcriptionURL: URL {
        baseURL.appendingPathComponent("v1/audio/transcriptions")
    }

    public static var translationURL: URL {
        baseURL.appendingPathComponent("v1/audio/translations")
    }
}
