//
//  Validation.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/17.
//

import Foundation

// 유효한지에 대한 Bool타입과 errorLabel을 함께 전달
typealias ResultWithErrorLabel = (isValid: Bool, errorLabel: String)

struct Validation {
    func validateName(name: String?) -> ResultWithErrorLabel {
        let trimmedString = name?.trimmingCharacters(in: .whitespaces)
        guard let trimmedString = trimmedString, !trimmedString.isEmpty else { return (false, "값을 입력해주세요") }
        guard (2...7) ~= trimmedString.count else { return (false, "닉네임은 2자 이상 7자 이하로 입력해주세요") }
        guard nameValidation(name: trimmedString) else { return (false, "닉네임은 한글, 영문, 숫자만 가능해요") }
        return (true, "")
    }
    
    func validateTargetAmount(number: String?) -> ResultWithErrorLabel {
        guard let amount = number, !amount.isEmpty else { return (false, "값을 입력해주세요") }
        print(amount)
        guard (1...13) ~= amount.count else { return (false, "100억 미만의 숫자만 입력해주세요") }
        return (true, "")
    }
    
    private func nameValidation(name: String) -> Bool {
        // String -> Array
        let arr = Array(name)
        // 정규식 pattern. 한글, 영어, 숫자만 있어야 함
        let pattern = "[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]"
        if let regex = try? NSRegularExpression(pattern: pattern, options:  .caseInsensitive) {
            var index = 0
            while index < arr.count {
                let results = regex.matches(in: String(arr[index]), range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    private func textFieldNullCheck(_ text: String) -> Bool {
        return text.isEmpty ? false : true
    }
    
}
