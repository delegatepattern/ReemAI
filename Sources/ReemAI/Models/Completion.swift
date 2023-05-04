//
//  Completion.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation

// MARK: -  Completion Request
public struct Completion {
    public struct Request {
        let prompt: String
        let model: String
        let maxTokens: Int
        let temperature: Double
    }
}

// MARK: Request Encodable
extension Completion.Request: Encodable {
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
        case temperature
    }
}

// MARK: - Completion Result
extension Completion: Decodable {
    public struct Result: Decodable {
        public let id: String
        public let object: ObjectType
        public let model: CompletionModel
        public let created: String
        public let choices: [Choices]
        public let usage: Usage

        enum CodingKeys: String, CodingKey {
            case id
            case object
            case model
            case created
            case choices
            case usage
        }

        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Completion.Result.CodingKeys> = try decoder.container(keyedBy: Completion.Result.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: Completion.Result.CodingKeys.id)

            let objectString = try container.decode(String.self, forKey: .object)
            self.object = ObjectType(rawValue: objectString) ?? .unknown

            let modelString = try container.decode(String.self, forKey: .model)
            self.model = CompletionModel(rawValue: modelString) ?? .unknown
            
            self.created = try container.decode(Double.self, forKey: Completion.Result.CodingKeys.created).formattedDate
            self.choices = try container.decode([Completion.Result.Choices].self, forKey: Completion.Result.CodingKeys.choices)
            self.usage = try container.decode(Completion.Result.Usage.self, forKey: Completion.Result.CodingKeys.usage)
        }
    }
}

// MARK: Choices
public extension Completion.Result {
    struct Choices: Decodable {
        public let text: String

        enum CodingKeys: String, CodingKey {
            case text
        }
    }
}

public extension Completion.Result {
    struct Usage: Decodable {
        public let promptTokens: Int
        public let completionTokens: Int
        public let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

// MARK: Extension Int
public extension Double {
    var formattedDate: String {
        let timeStamp = Date(timeIntervalSince1970: self)
        return timeStamp.formatted()
    }
}
