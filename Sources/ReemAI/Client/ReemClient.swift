//
//  ReemClient.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation

public class ReemClient {
    private let accessToken: String
    private let organizationID: String?
    private let session: URLSession = URLSession.shared

    public init(accessToken: String, organizationID: String? = nil ) {
        self.accessToken = accessToken
        self.organizationID = organizationID
    }
}

// Completions.
public extension ReemClient {
    func sendCompletions(prompt: String,
                         model: CompletionModel = CompletionModel.davinci,
                         maxTokens: Int = 16,
                         temperature: Double = 0) async throws -> Completion.Result? {
        let value = Completion.Request(prompt: prompt, model: model.named, maxTokens: maxTokens, temperature: temperature)
        let request = PostRequest<Completion.Request, Completion.Result>(url: OpenAIEndpoint.completionsURL, accessToken: accessToken,
                                                                         organizationID: organizationID, session: session, value: value)
        do { return try await request.execute() }
        catch {
            print("Error during network request: \(error.localizedDescription)")
            return nil
        }
    }
}

// Chat.
public extension ReemClient {
    func sendChat(model: ChatModel = ChatModel.gpt35turbo,
                  messages:[ Chat.Message],
                  temperature: Double? = 1,
                  topProbability: Double? = 1,
                  numberOfChoices: Int? = 1,
                  stop: [String]? = nil,
                  maxTokens: Double? = nil,
                  presencePenalty: Double? = 0,
                  frequencyPenalty: Double? = 0,
                  logitBias: [Int: Double]? = nil,
                  user: String? = nil ) async throws -> Chat.Result? {
        let value = Chat.Request(model: model,
                                 messages: messages,
                                 temperature: temperature,
                                 topProbability: topProbability,
                                 numberOfChoices: numberOfChoices,
                                 stop: stop,
                                 maxTokens: maxTokens,
                                 presencePenalty: presencePenalty,
                                 frequencyPenalty: frequencyPenalty,
                                 logitBias: logitBias,
                                 user: user)

        let request = PostRequest<Chat.Request, Chat.Result>(url: OpenAIEndpoint.chatURL, accessToken: accessToken,
                                                             organizationID: organizationID,
                                                             session: session, value: value)
        do { return try await request.execute() }
        catch {
            print("Error during network request: \(error.localizedDescription)")
            return nil
        }
    }
}

// Edtis
public extension ReemClient {
    func sendEdit(model: EditModel = .textDavinci,
                  input: String,
                  instruction: String,
                  number: Int,
                  temperature: Double? = 1,
                  topProbability: Double? = 1 ) async throws -> Edit.Result? {
        let value = Edit.Request(model: .textDavinci, input: input, instruction: instruction , number: number,
                                 temperature: temperature, topProbability: topProbability)
        let request = PostRequest<Edit.Request, Edit.Result>(url: OpenAIEndpoint.editsURL, accessToken: accessToken,
                                                             organizationID: organizationID, session: session, value: value)

        do { return try await request.execute() }
        catch {
            print("Error during network request: \(error.localizedDescription)")
            return nil
        }
    }
}

// Image Generation.
public extension ReemClient {
    func generateImage(prompt: String,
                       number: Int? = 1,
                       size: Size = Size.small,
                       responseFormat: ImageReponseFormat = .url,
                       user: String? = nil) async throws -> ImageGeneration.Result? {
        let value = ImageGeneration.Request(prompt: prompt, number: number, size: size, responseFormat: responseFormat, user: user)
        let request = PostRequest<ImageGeneration.Request, ImageGeneration.Result>(url: OpenAIEndpoint.imageGenerateURL,
                                                                                   accessToken: accessToken,
                                                                                   organizationID: organizationID,
                                                                                   session: session,
                                                                                   value: value)
        do {
            return try await request.execute()
        }
        catch {
            print("Error during network request: \(error.localizedDescription)")
            return nil
        }
    }
}

// Transcribe - Whisper
public extension ReemClient {
    func transcribe(file: String,
                    prompt: String? = nil,
                    temperature: Double? = 0,
                    language: Language?) async throws -> AudioResult? {
        let value = AudioRequest(file: file, prompt: prompt, temperature: temperature, language: language)
        let request = FileUploadRequest<AudioRequest, AudioResult>(url: OpenAIEndpoint.transcriptionURL,
                                                                   accessToken: accessToken,
                                                                   organizationID: organizationID,
                                                                   value: value,
                                                                   mimeType: .wav)
        do {
            guard let body = request.body else { return nil }
            return try await request.performUpload(body)
        }
        catch {
            print("Error during network request: \(error)")
            return nil
        }

    }
}

// Translate - Whisper
public extension ReemClient {
    func translate(file: String,
                   prompt: String? = nil,
                   temperature: Double? = 0) async throws -> AudioResult? {
        let value = AudioRequest(file: file, prompt: prompt, temperature: temperature, language: nil)
        let request = FileUploadRequest<AudioRequest, AudioResult>(url: OpenAIEndpoint.translationURL,
                                                                   accessToken: accessToken,
                                                                   organizationID: organizationID,
                                                                   value: value,
                                                                   mimeType: .mp3)
        do {
            guard let body = request.body else { return nil }
            return try await request.performUpload(body)
        }
        catch {
            print("Error during network request: \(error)")
            return nil
        }
    }
}
