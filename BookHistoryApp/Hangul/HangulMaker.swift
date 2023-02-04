//
//  HangulMaker.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/01.
//

import Foundation

class HangulMaker{
    
    static let base_code: Int = 0xAC00
    static let base_init_soundCode: Int = 0x1100
    static let base_vowel_code: Int = 0x1161
    
    static let initial_sounds: String = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"
    
    static let middle_vowels: [String] = [ "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ",
                                        "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ",
                                        "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ" ]
    
    static let final_consonants: [String?] = [nil, "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ",
                                       "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ",
                                       "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ" ]
    
    init(){
        let k = HangulMaker.getSingleLetter(HangulMaker.getInitSoundCode(Character("ㄱ")))
        print("kfgagd : k")
    }
    
    public static func getInitSoundCode(_ ch: Character) -> Int{
        
        if let index: String.Index = initial_sounds.firstIndex(of: ch){
            return initial_sounds.distance(from: initial_sounds.startIndex, to: index)
        }
        return -1
    }
    
    public static func getVowelCode(_ str: String) -> Int{
        let cnt: Int = middle_vowels.count
        
        for i in 0..<cnt{
            if middle_vowels[i] == str{
                return i
            }
        }
        return -1
    }
    
    public static func getVowelCode(_ ch: Character) -> Int{
        return getVowelCode(String(ch))
    }
    
    public static func getFinalConsonantCode(_ str: String) -> Int{
        let cnt: Int = final_consonants.count
        
        for i in 0..<cnt{
            if final_consonants[i] == str{
                return i
            }
        }
        return -1
    }
    
    public static func getFinalConsonantCode(_ ch: Character?) -> Int{
        if let ch = ch {
            return getFinalConsonantCode(String(ch))
        }
        return getFinalConsonantCode(String(""))
        
    }
    
    public static func getSingleLetter(_ value: Int) -> Character?{
        
        //        byte[] bytes = BitConverter.GetBytes((short)(BASE_INIT + value));
        //        return Char.Parse(Encoding.Unicode.GetString(bytes));
        
        if let scalar = Unicode.Scalar(HangulMaker.base_init_soundCode + value){
        
            return Character(scalar)
        }
        return nil
    }
    
    public static func getSingleVowel(_ value: Int) -> Character?{
        
        if let scalar = Unicode.Scalar(HangulMaker.base_vowel_code + value){
            return Character(scalar)
        }
        return nil
    }

    public static func getComplteLetter(_ init_sound: Int ,_ vowel: Int,_ final: Int) -> Character?{
        var tempFinalConsonant: Int = 0
        if final >= 0{
            tempFinalConsonant = final
        }
        let jungcnt = middle_vowels.count
        let jongcnt = final_consonants.count
        let base_code = HangulMaker.base_code
        
        let completeChar: Int = init_sound * jungcnt * jongcnt + vowel * jongcnt + tempFinalConsonant + base_code
        guard let scalar: Unicode.Scalar = Unicode.Scalar(completeChar) else {return nil}
        return Character(scalar)
        
    }
    
    public static func isDoubleFinalConsonant(_ ch: Character?) -> Bool{
        let code = getFinalConsonantCode(ch)
        return code == 1 || code == 4 || code == 8 || code == 17
    }
    
    public static func isDoubleVowel(_ ch: Character) -> Bool{
        let code = getVowelCode(ch)
        return enableDoubleVowel(code)
    }
}


extension HangulMaker{
    static func enableDoubleVowel(_ code: Int) -> Bool{
        return (code == 8) || (code == 13) || (code == 17) || (code == 18)
    }
    static func isInitSound(_ ch: Character) -> Bool{
        return getInitSoundCode(ch) != -1
    }
    static func isVowel(_ ch: Character) -> Bool{
        return getVowelCode(ch) != -1
    }
    static func isCharKey(_ ch: Character) -> Bool{
        return ch.isLetter
    }
    static func isFinalConsonant(_ ch: Character) -> Bool{
        return getFinalConsonantCode(ch) != -1
    }
}

extension HangulMaker{
    static func checkIsDoublejongSung(_ str: String) -> String{
        if str.length <= 1{
            return str
        }
        if str.length == 2{
            switch str{
            case "ㄱㅅ":
                return "ㄳ"
            case "ㄴㅈ":
                return "ㄵ"
            case "ㄹㄱ":
                return "ㄺ"
            case "ㄹㅁ":
                return "ㄻ"
            case "ㄹㅂ":
                return "ㄼ"
            case "ㄹㅅ":
                return "ㄽ"
            case "ㄹㅌ":
                return "ㄾ"
            case "ㄹㅍ":
                return "ㄿ"
            case "ㄹㅎ":
                return "ㅀ"
            case "ㅂㅅ":
                return "ㅄ"
            default:
                break
            }
        }
        return str
    }
    static func checkIsDoubleVowel(_ str: String) -> String{
        if str.length <= 1{
            return str
        }
        
        if str.length == 2{
            switch str{
            case "ㅗㅏ":
                return "ㅘ"
            case "ㅗㅐ":
                return "ㅙ"
            case "ㅗㅣ":
                return "ㅚ"
            case "ㅜㅓ":
                return "ㅝ"
            case "ㅜㅔ":
                return "ㅞ"
            case "ㅜㅣ":
                return "ㅟ"
            case "ㅡㅣ":
                return "ㅢ"
            case "ㅠㅣ":
                return "ㅝ"
            default:
                break
            }
        }
        return str
    }
}

extension String{
    
    static func emptyString() -> String {
        return ""
    }
}
