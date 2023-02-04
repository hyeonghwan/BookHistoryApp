//
//  HGState.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/01.
//

import Foundation

enum HanguleStateType{
    case TURN_INIT_SOUND
    case TURN_VOWEL
    case TURN_FINAL_CONSONANT
    case none
}

class HanguleState{
    var vowel_Init_Char = Character("\0") // 초성 초기 문자
    var final_Init_Char = Character("\0") // 종성 초기 문자
    
    var init_sound: Int                 //초성
    var vowel: Int                      //중성(모음)
    var vowel_first: Character         //첫 모음
    var isVowelPossible: Bool             //이중 모음이 가능 여부
    var finalConsonant: Int            //종성
    var finalConsonant_first: Character? //종성의 첫 받침
    var finalConsonant_second: Character  //종성의 마지막 받침(이중 받침일 때 의미가 있음)
    var isFinalConsonantPossible:  Bool  //이중 받침 가능 여부

    var state: HanguleStateType = .none

    private init(_ vowel_Init_Char: Character, _ final_Init_Char: Character){
        init_sound = -1;
        
        vowel = -1;
        vowel_first = vowel_Init_Char
        
        isVowelPossible = false
        isFinalConsonantPossible = false
        
        finalConsonant = -1
        finalConsonant_first = final_Init_Char
        finalConsonant_second = final_Init_Char
    }
    convenience init(_ ch: Character = Character("\0")){
        self.init(ch,ch)
        setStateInitSound()
        
    }

    func hangule_init(){
        state = .TURN_INIT_SOUND
        init_sound = -1;
        
        vowel = -1;
        vowel_first = vowel_Init_Char
        
        isVowelPossible = false
        isFinalConsonantPossible = false
        
        finalConsonant = -1
        finalConsonant_first = final_Init_Char
        finalConsonant_second = final_Init_Char
    }
}

// MARK: - About Hangul Get character method
extension HanguleState{
    
    
    /// 현재 HGState의 Hangul 문자 구하는 method
    /// - Returns: complted Hangul
    func getCompleteChar() -> Character{
        if let complteChar = HangulMaker.getComplteLetter(init_sound, vowel, finalConsonant) {
            return complteChar
        }else{
            print("\(#file) \(#function) \(#line)")
            fatalError("완전한 문자를 만들 수 없습니다 내부 코드를 확인해주세요")
        }
    }
    

    
    
    
    /// 이중 모음인지 확인하는 메소드
    /// - Returns: 이중모음의 Bool값
    func isDoubleVowel() -> Bool{
        
        let checkDoubleVowel = HangulMaker.enableDoubleVowel(vowel)
        return isVowelPossible && (checkDoubleVowel == false) && (existFirstFinalConsonant() == false)
    }
    
    
    /// 종성을 설정하였는지 확인하는 메소드
    /// - Returns: 종성을 설정하였는지 의 Bool값
    func existFirstFinalConsonant() -> Bool{
        return finalConsonant_first != final_Init_Char
    }
    

    /// 종성이 존재하는지 확인하는 메소드
    /// - Returns: 종성의 존재 여부
    func existLastFinalConsonant() -> Bool{
        return finalConsonant_second != final_Init_Char
    }

    
    /// 초성만 있는지 확인하는 메소드
    /// - Returns: 초성만 있는 지의 여부 Bool값
    /// 초성만 있을 때는 현재 상태는 모음을 기대하는 상태이면서 모음이 없을 때
    func isInitSound() -> Bool{
        return state == .TURN_VOWEL && !existVowel()
    }
    
    
    /// 단일 모음인지 확인하는 메소드
    /// - Returns: 단일 모음인지의 여부 Bool값
    func isSingleVowel() -> Bool{
        
        // 먼저 첫 모음이 vowel이 아니면 단일 모음이 아니다.
        if vowel != HangulMaker.getVowelCode(vowel_first){
           return false
        }
        // 만약 모음이 존재하면서 모음을 기대하는 상태이거나 종성을 기대하는 상태인데 종성이 없는 상태이면 단일 모음이다.
        return (state == .TURN_VOWEL && existVowel() ||
                (state == .TURN_FINAL_CONSONANT) && (!existFinalConsonant()))
        
    }

    /// 모음이 존재하는지 확인하는 메소드
    /// - Returns: 모음의 존재여부 Bool값
    func existVowel() -> Bool{
        
        //모음이 초기 값이 아니면서 -1이 아니어야 합니다.
        let value = Int(vowel_Init_Char.unicodeScalars.first!.value)
        return (vowel != value) && vowel != -1
        
    }
    
    
    /// 종성이 존재하는지 확인하는 메소드
    /// - Returns: 종성의 존재 여부 Bool 값
    func existFinalConsonant() -> Bool{
        
        //종성이 초기 값이 아니면서 -1도 아니면 종성이 존재하는 것입니다.
        let value = Int(final_Init_Char.unicodeScalars.first!.value)
        return (finalConsonant != value) && finalConsonant != -1
        
    }
    
    /// 종성이 하나인지 확인하는 메서드
    /// - Returns: 종성이 한개인지 여부 Bool값
    /// 현재 상태가 종성이 오기를 기대하면서 첫 종성이 존재하고 마지막 종성이 존재하지 않을 때입니다.
    func isSingleFinalConsonant() -> Bool{
        return state == .TURN_FINAL_CONSONANT && existFirstFinalConsonant() && (!existLastFinalConsonant())
    }
    
    
    /// 가득찬지 여부 (한글자의 입력에서 더이상 입력을 받을수 없는 상태 확인여부)
    /// - Returns: bool
    ///   종성의 첫번째 와 마지막의 여부를 확인해서 full의 여부 식별 가능 ( 종성이 가득 찾기 때문에 더이상 한글자에서 입력 받을수 없음)
    func isFull() -> Bool{
        return existFirstFinalConsonant() && existLastFinalConsonant()
    }
    
    
    /// 이중 종성이 가능한지 확인하는 메서드
    /// - Returns: Bool
    ///  이중 종성이 가능한 자음은 ㄱ, ㄴ, ㄹ, ㅂ 입니다.
    func enableDoubleFinalConsonant() -> Bool{
        return finalConsonant == 1 || finalConsonant == 4 || finalConsonant == 8 || finalConsonant == 17;
    }

    
    /// 모음을 설정하는 메소드
    /// - Parameter ch: 입력 문자
    func setVowel(_ ch: Character){
        //hangulMaker의 정적 메소드를 이용하여 이중 모음이 가능한지 확인
        if HangulMaker.isDoubleVowel(ch){
            // 가능하면 vowelPossible을 true로 설정하고 현재 상태를 모음을 기대하는 상태로 설정합니다.
            isVowelPossible = true
            state = .TURN_VOWEL
        }else{
            //그렇지 않으면 종성을 기대하는 상태로 전이합니다.
            state = .TURN_FINAL_CONSONANT
        }
        // 초기 모음을 설정합니다.
        vowel_first = ch
    }
  
    
    ///  초성을 문자열에 추가하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch:  입력한 문자
    /// - Returns: 문자열에 입력한 문자의 삽입 여부 Bool
    func inputAtInitSound(ref source: inout String, ch: Character) -> Bool{
        
        //먼저 다음 상태는 중성을 기대하는 상태로 전이
        state = .TURN_VOWEL
        
        init_sound = HangulMaker.getInitSoundCode(ch)
        
        if init_sound >= 0{
            //초성 문자가 맞으면 초성 코드 값은 0보다 크거나 같다.
            // 이 때 초성으로만 구성한 한글을 기존 문자열에 더한다.
            if let character = HangulMaker.getSingleLetter(init_sound){
                source += String(character)
                return true
            }else{
                print("\(#file) \(#function) \(#line)")
                fatalError("inputAtInitSound character optional unwrapping error ouccr")
            }
        }
        // 만약 초성 코드 값이 0보다 크거나 같지 않으면 실패를 반환합니다.
        return false
    }

    
    /// 첫 모음을 추가하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch: 입력한 문자
    /// - Returns: 문자열에 입력한 문자의 삽입 여부 Bool
    func inputFirstVowel(ref source: inout String, ch: Character) -> Bool{
        // 먼저 문자의 중성 코드 값을 구한다.
        vowel = HangulMaker.getVowelCode(ch)
        
        // 만약 중성 코드가 아니면 상태를 초기 상태로 전이합니다.
        if (vowel < 0){ state = .TURN_INIT_SOUND; return false}
        
        // 초성이 없을 때는 모음 하나로 구성한 한글을 문자열에 추가하고 Init 메서드를 호출합니다.
        if (init_sound < 0){
            if let character = HangulMaker.getSingleVowel(HangulMaker.getVowelCode(ch)){
                source += String(character)
            }else{
                print("\(#file) \(#function) \(#line)")
                fatalError("inputFirstVowel character optional unwrapping error ouccr")
            }
            hangule_init();
        }else{
            // 초성이 있을 때는 중성을 설정합니다.
            setVowel(ch)
            
            // 그리고 마지막 문자를 중성을 설정한 한글로 변경합니다.
            print("before : \(source)")
            print("length: \(source.length)")
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            print("source[..<index] : \(source[..<index])")
            source = String(source[..<index])
            let compltedString = getCompleteChar()
            source += String(compltedString)
        }
        
        return true
    }
    
    
    
    ///  두 번째 모음을 추가하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch:  입력받은 문자
    /// - Returns: 성공여부
    func inputSecondVowel(ref source: inout String , ch : Character) -> Bool{
        
        // 현재 첫번째 모음 문자와 입력 인자로 받은 문자로 구성한 문자열을 만듭니다.
        var tempVowel = String.emptyString()
        tempVowel += vowel_first.description
        tempVowel += ch.description
        
        let twoStr = HangulMaker.checkIsDoubleVowel(tempVowel)
        
        // 구성한 문자열로 중성 코드 값을 구합니다.
        let temp: Int = HangulMaker.getVowelCode(twoStr)
        
        // 중성 코드 값이 0 보다 크거나 같으면 유효한 모음입니다.
        // 이중 모음을 구성한 문자열을 모음으로 설정합니다.
        if temp >= 0{
            vowel = temp
            
            // 원본 문자열의 맨 마지막 문자를 새로 형성한 문자열로 변경합니다.
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            let compltedString = getCompleteChar()
            source += String(compltedString)
            
            // 종성이 오기를 기대하는 상태로 전이합니다.
            setStateFinalConsonant()
            
            return true
        }else{
            // 그렇지 않으면 첫 종성을 기대하는 생태로 전이합니다.
            setStateFinalConsonant()
            
            // 그리고 다시 입력할 수 있게 false를 반환합니다.
            return false
        }
    }
    
    
    
    /// 첫 종성을 추가하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch: 입력받은 문자
    /// - Returns: 성공 여부
    func inputFirstFinalConsonant(ref source: inout String , ch: Character?) -> Bool{
        //먼저 입력인자로 받은 문자를 종성 코드로 변환합니다.
        
        finalConsonant = HangulMaker.getFinalConsonantCode(ch)
        
        
        if finalConsonant > 0 {
            // 종성 코드가 유효하면
            // 원본 문자열의 마지막 문자를 종성을 추가한 완성형 문자로 변경
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            let compltedString = getCompleteChar()
            source += String(compltedString)
            
            setFirstFinalConsonant(ch: ch)
            return true
        }
        
        if let ch = ch{
            
            // 입력 인자로 받은 문자가 모음일 때는 초기화를 하고
            // false를 반환하여 다시 입력 시도할 수 있게 합니다.
            if HangulMaker.getVowelCode(ch) >= 0 {
                hangule_init()
                return false
            }
            
            // 종성으로 쓸 수 없는 자음이 왔을 때도 초기화를 합니다.
            if HangulMaker.getInitSoundCode(ch) >= 0{
                hangule_init()
                isFinalConsonantPossible = false
                finalConsonant = 0
                return false
            }
            
            return false
        }else{
            // ch 가 빈문자열 == nil
           return false
        }
        
    }
    
    
    /// 첫 종성을 설정하는 메소드
    /// - Parameter ch: 입력 받은 문자
    func setFirstFinalConsonant(ch: Character?){
        // 입력 인자로 받은 문자를 첫 종성 문자로 설정합니다.
        finalConsonant_first = ch
        
        //이중 받침이 가능한지 확인합니다.
        isFinalConsonantPossible = enableDoubleFinalConsonant()
    }
    
    
    /// 두번째 종성을 추가하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch: 입력받은 문자
    /// - Returns: 성공여부
    func inputSecondFinalConsonant(ref source: inout String, ch: Character) -> Bool{
        
        // 이중 받침이 가능하면 이중 모음을 설정하는 메서드를 호출합니다.
        if isFinalConsonantPossible{
            return setSecondFinalConsonant(ref: &source, ch: ch)
        }else{
            
            // 그렇지 않으면 입력 인자로 받은 문자가 초성인지 확인하여
            // 초성이면 초기 상태로 전이합니다.
            if HangulMaker.getInitSoundCode(ch) >= 0 {
                hangule_init()
            }
            else{
                // 그렇지 않으면 마지막 문자의 종성을 새로운 초성으로 설정합니다.
                lastFinalConsonantToInitSound(ref: &source)
            }
            return false
        }
    }
    
    
    /// 두번째 받침을 설정하는 메소드
    /// - Parameters:
    ///   - source: 문자열
    ///   - ch: 입력받은 문자
    /// - Returns: 성공여부
    func setSecondFinalConsonant(ref source: inout String, ch: Character) -> Bool{
        // 더 이상 종성은 받을 수 없습니다.
        isFinalConsonantPossible = false
        
        var tempfinal_consonant = ""
        tempfinal_consonant += String(finalConsonant_first ?? Character("\0"))
        tempfinal_consonant += String(ch)
        print("tempfinal_consonant :\(tempfinal_consonant)")
        
        let tempFinalConsonantOneValue = HangulMaker.checkIsDoublejongSung(tempfinal_consonant)
        
        //   KoreanCharMaker의 정적 메서드 getFinalConsonantCode로 종성 코드를 구합니다.
        let temp: Int = HangulMaker.getFinalConsonantCode(tempFinalConsonantOneValue)
        
        // 종성 코드가 0보다 크면 이중 받침입니다.
        // 최종 종성을 입력 받은 문자로 설정하고 종성을 임시로 구성한 문자열로 설정합니다.
        if temp > 0 {
            finalConsonant_second = ch
            finalConsonant = temp
            
            // 원본 문자열의 마지막 문자열 완성한 문자로 변경합니다.
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            let compltedString = getCompleteChar()
            source += String(compltedString)
            
            return true
        }
        
        return false
        
    }
    
    func lastFinalConsonantToInitSound(ref source: inout String){
        
        if isFull(){
            // 이중 받침으로 구성한 문자일 때는
            // 마지막 문자를 마지막 받침만 없는 문자로 변경
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            finalConsonant = HangulMaker.getFinalConsonantCode(finalConsonant_first)
            let compltedString = getCompleteChar()
            source += String(compltedString)
            
            // 초성 코드 구하기
            init_sound = HangulMaker.getInitSoundCode(finalConsonant_second)
            
        }else{
            // 그렇지 않다면 종성 문자를 얻어와서
            // 원본 문자열의 마지막 문자에서 종성을 제거합니다.
            let tempInit_sound: Character
            
            if finalConsonant_first != nil{
                tempInit_sound = finalConsonant_first!
            }else{
                tempInit_sound = Character("\0")
            }
            
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            finalConsonant = HangulMaker.getFinalConsonantCode(finalConsonant_first)
            
            clearFinalConsonant()
            
            let compltedString = getCompleteChar()
            
            
            
            source += String(compltedString)
            
            // 그리고 종성으로 초성 코드를 구한다.
            init_sound = HangulMaker.getInitSoundCode(tempInit_sound)
        }
        // 받침으로 만든 초성 코드로 초성 글자를 만들어
        // 원본 문자열에 추가하고 상태를 전이합니다.
        if let value = HangulMaker.getSingleLetter(init_sound){
            source += String(value)
            setStateVowel()
        }else{
            print("\(#file) \(#function) \(#line)")
            fatalError("getSingleJa error occur")
        }
    }
    
    
    ///  종성을 지우는 메서드
    ///  상태를 종성을 기대하는 상태로 전이하고 모음을 설정합니다.
    func clearFinalConsonant(){
        setStateFinalConsonant()
        setVowel(vowel_first)
    }
    
    
    ///마지막 모음을 지우는 메서드
    func clearLastVowel(){
        
        // 상태를 모음을 기대하는 상태로 전이합니다
        // 모음 코드를 구하여 설정합니다.
        state = .TURN_VOWEL
        vowel = HangulMaker.getVowelCode(vowel_first)
    }

    
    /// 마지막 종성을 지우는 메서드
    /// 마지막 종성을 기대하는 상태로 전이한니다.
    func clearLastFinalConsonant(){
        state = .TURN_FINAL_CONSONANT
        finalConsonant_second = final_Init_Char
        finalConsonant = HangulMaker.getFinalConsonantCode(finalConsonant_first)
        isFinalConsonantPossible = true
    }
    
    
    /// 초성으로 한 글자를 구하는 메소드
    /// - Returns: 한 글자
    func getLetterFormInitSound() -> Character{
        return HangulMaker.getSingleLetter(init_sound) ?? Character("\0")
    }
    
    ///  첫 종성이 있는지 확인하는 메서드
    /// - Returns: 첫 종성 여부
    func isFirstFinalConsonant() -> Bool{
        return finalConsonant > 0
    }
    
}


// MARK: - 상태 전이 메서드 extension
extension HanguleState{
    
    ///  초성 상태로 전이하는 메서드
    func setStateInitSound(){
        self.state = .TURN_INIT_SOUND
    }
    
    /// 중성 상태로 전이하는 메서드
    func setStateVowel(){
        self.state = .TURN_VOWEL
        vowel = -1
        finalConsonant = -1
        isVowelPossible = false
        finalConsonant_first = final_Init_Char
        finalConsonant_second = final_Init_Char
    }
    
    /// 종성 상태를 설정하는 메서드
    func setStateFinalConsonant(){
        state = .TURN_FINAL_CONSONANT
        finalConsonant = -1
        finalConsonant_first = final_Init_Char
        finalConsonant_second = final_Init_Char
    }
}



