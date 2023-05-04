# ReemAI

ReemAI is an **unofficial, community-maintained** open source library written in Swift for the OpenAI API. It provides an easy-to-use interface for interacting with the OpenAI API, allowing you to quickly integrate advanced AI capabilities into your Swift projects.

## Installation
To install ReemAI using Swift Package Manager, add the following line to your **Package.swift** file:

```swift
dependencies: [
    .package(url: "https://github.com/delegatepattern/ReemAI.git", from: "1.0.0")
]
```
***NOTE***: To ensure up-to-date functionality and stay current with new releases and updates, this library supports iOS 15.0 and above

## Usage
To use ReemAI, you must first obtain an API key from the OpenAI official developer page. It is **HIGHLY** recommended that you load this key through environment variables instead of hardcoding it in your source code.

To create a new instance of the **ReemClient** class and connect to the OpenAI API, use the following code:

```swift
let client = ReemClient(accesstoken: YOUR_TOKEN)
```
If you are part of an organization and want to specify an organization ID, you can use the following code instead:

```swift
let client = ReemClient(accesstoken: YOUR_TOKEN, organizationID: YOUR_ORG_ID)
```

## Endpoints
ReemAI currently supports the following endpoints:

### **Completions**
To send a prompt and receive a completion response, use the following code:

```swift
do {
    let result = try await client.sendCompletions(prompt: "What is today's day of the week?")
    text = result?.choices[0].text ?? ""
} catch {
    print("error occurred: \(error.localizedDescription)")
}
```

### **Chat**
To start a chat session and send/receive messages, use the following code:


```swift
do {
    let messages: [Chat.Message] = [
        Chat.Message(role: Role.system, content: "You are a helpful assistant."),
        Chat.Message(role: Role.user, content: "Who won the world cup for soccer in 2018?"),
        Chat.Message(role: Role.assistant, content: "What do you think about the 2022 soccer event in Qatar?"),
        Chat.Message(role: Role.assistant, content: "Where is the city that was the main event for the FIFA 2022?")
    ]
    let result = try await client.sendChat(messages: messages)
    guard let result = result else { return }
    text = result.choices[0].message.content
} catch {
    print("there is an error: \(error.localizedDescription)")
}
```
### **Edits**
To send a piece of text and receive an edited version, use the following code:

```swift
do {
    let input = "I feel fery sleeby right no"
    let instruct = "Fix the spelling mistakes."
    let result = try await client.sendEdit(input: input, instruction: instruct, number: 1)
    guard let result = result else { return }
    text = result.choices[0].text
} catch {
    print("there is an error: \(error.localizedDescription)")
}
```
### **Image Generation**
To generate an image based on a prompt, use the following code:
```swift
do {
    let result = try await client.generateImage(prompt: "Your Prompt goes here..")
    guard let item = result else { return }
    self.url = item.data[0].url
} catch {
    print("there is an error: \(error.localizedDescription)")
}
```

### **Transcription**


```swift
do {
    let fileURL = Bundle.main.url(forResource: "file_name", withExtension: "wav")!
    let filePath = fileURL.path
    let result = try await client.transcribe(file: filePath, language: .en)
    guard let result = result else { return }
    let text = result.text
} catch {
    print("Error: \(error.localizedDescription)")
}
```

### **Translation**
```swift
do {
    let fileURL = Bundle.main.url(forResource: "file_name", withExtension: "mp3")!
    let filePath = fileURL.path
    let result = try await client.translate(file: filePath)
    guard let result = result else { return }
    let text = result.text
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Contrubition
As a community-maintained library, we are committed to maintaining this library by addressing issues and reviewing and merging pull requests. 
If you encounter any issues or have any suggestions, please don't hesitate to open an issue or pull request.

## License
ReemAI is licensed under the MIT License, a permissive open-source license that allows forking and modification of the library.

The MIT License (MIT)

Copyright (c) 2023 Kasem Al

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Questions 
If you have any questions, please don't hesitate to reach out to us.

