//
//  APICaller.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/01.
//

import Foundation
import OpenAISwift

class APICaller {
    static let shared = APICaller()
    
    enum Constants {
        static let key = "API KEY"
    }
    var client: OpenAISwift?
    
    private init() {}
    
    func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
