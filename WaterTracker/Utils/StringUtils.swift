//
//  StringUtils.swift
//  WaterTracker
//
//  Created by Nik on 25.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit

extension String {

    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn( matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }

    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn( matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet as CharacterSet) != nil
    }

    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn( matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }

    // Returns true if the string represents a proper numeric value.
    // This method uses the device's current locale setting to determine
    // which decimal separator it will accept.
    func isNumeric() -> Bool {
        let scanner = Scanner(string: self)

        // A newly-created scanner has no locale by default.
        // We'll set our scanner's locale to the user's locale
        // so that it recognizes the decimal separator that
        // the user expects (for example, in North America,
        // "." is the decimal separator, while in many parts
        // of Europe, "," is used).
        scanner.locale = Locale.current

        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }

    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func isNotEmpty() -> Bool {
        return !self.trim().isEmpty
    }

    func containsIgnoringCase( find: String) -> Bool {
        return (range(of: find) != nil)
    }

    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }

    func size(with font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)
        return size
    }
}
