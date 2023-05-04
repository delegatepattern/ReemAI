//
//  Chat.swift
//  Kasem
//
//  Created by Qasim Al on 4/30/23.
//

import Foundation

public typealias Usage = Completion.Result.Usage
// MARK: Chat Request
public struct Chat {
    public struct Request: Encodable {
        let model: ChatModel
        let messages: [Message]
        let temperature: Double?
        let topProbability: Double?
        let numberOfChoices: Int?
        let stop: [String]?
        let maxTokens: Double?
        let presencePenalty: Double?
        let frequencyPenalty: Double?
        let logitBias: [Int: Double]?
        let user: String?


        enum CodingKeys: String, CodingKey {
            case model
            case messages
            case temperature
            case topProbability = "top_p"
            case numberOfChoices = "n"
            case stop
            case maxTokens = "max_tokens"
            case presencePenalty = "presence_penalty"
            case frequencyPenalty = "frequency_penalty"
            case logitBias = "logit_bias"
            case user

        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(model.rawValue, forKey: .model)
            try container.encode(messages, forKey: .messages)
            try container.encodeIfPresent(temperature, forKey: .temperature)
            try container.encodeIfPresent(topProbability, forKey: .topProbability)
            try container.encodeIfPresent(numberOfChoices, forKey: .numberOfChoices)
            try container.encodeIfPresent(stop, forKey: .stop)
            try container.encodeIfPresent(maxTokens, forKey: .maxTokens)
            try container.encodeIfPresent(presencePenalty, forKey: .presencePenalty)
            try container.encodeIfPresent(frequencyPenalty, forKey: .frequencyPenalty)
            try container.encodeIfPresent(logitBias, forKey: .logitBias)
            try container.encodeIfPresent(user, forKey: .user)
        }
    }
}

public extension Chat {
    struct Message: Codable {
        public let role: Role
        public let content: String

        enum CodingKeys: String, CodingKey {
            case role
            case content
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(role.rawValue, forKey: .role)
            try container.encode(content, forKey: .content)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let roleString = try container.decode(String.self, forKey: .role)
            self.role = Role(rawValue: roleString) ?? .user
            self.content = try container.decode(String.self, forKey: .content)
        }

        public init(role: Role, content: String) {
            self.role = role
            self.content = content
        }
    }
}

// MARK: Chat Result
public extension Chat {
    struct Result: Decodable {
        public let id: String
        public let object: ObjectType
        public let created: String
        public let choices: [Choice]
        public let usage: Usage

        enum CodingKeys: String, CodingKey {
            case id
            case object
            case created
            case choices
            case usage
        }

        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Chat.Result.CodingKeys> = try decoder.container(keyedBy: Chat.Result.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: Chat.Result.CodingKeys.id)

            let objectString = try container.decode(String.self, forKey: .object)
            self.object = ObjectType(rawValue: objectString) ?? .unknown

            self.created = try container.decode(Double.self, forKey: Chat.Result.CodingKeys.created).formattedDate
            self.choices = try container.decode([Chat.Result.Choice].self, forKey: Chat.Result.CodingKeys.choices)
            self.usage = try container.decode(Usage.self, forKey: Chat.Result.CodingKeys.usage)
        }
    }
}

public extension Chat.Result {
    struct Choice: Decodable {
        public let message: Chat.Message

        enum CodingKeys: String, CodingKey {
            case message
        }
    }
}
