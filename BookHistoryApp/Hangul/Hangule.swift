//
//  Hangule.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/02.
//

import Foundation


class Hangule{
    
    private var hanguleState: HanguleState
    
    private var source: String = ""
    
    public init(){
        self.hanguleState = HanguleState()
    }
    
    func getTotalString() -> String{
        return source
    }
    
    private func resetState() {
        hanguleState.hangule_init()
    }
    
    public func inputLetter(_ ch: Character?){
        if (ch == nil){
            removeKeyPressed()
            return
        }
        guard let ch = ch else { return }
        
        if let value = ch.unicodeScalars.first?.value{
            if (((value >= 97) && (value <= 122)) || ((value >= 65) && (value <= 90))) || (!ch.isLetter){
                source += String(ch)
                hanguleState.hangule_init()
                return
            }
        }
        
        switch hanguleState.state{
        case .TURN_INIT_SOUND:
            inputInitSoundProc(ch: ch)
            break
        case .TURN_VOWEL:
            inputVowelProc(ch: ch)
            break
        case .TURN_FINAL_CONSONANT:
            inputFinalConsonantProc(ch: ch)
            break
        case .none:
            fatalError("error occur")
        }
        
    }
    

    private func inputNoKorea(ch: Character){
        resetState()
        source += String(ch)
    }
    
    private func inputInitSoundProc(ch: Character){
        if (!hanguleState.inputAtInitSound(ref: &source, ch: ch)){
            inputLetter(ch)
        }
    }
    
    private func inputVowelProc(ch: Character){
        if (hanguleState.existVowel() == false){
            if hanguleState.inputFirstVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }else{
            if hanguleState.inputSecondVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }
    }
    
    private func inputFinalConsonantProc(ch: Character){
        if hanguleState.isFirstFinalConsonant() == false{
            if hanguleState.inputFirstFinalConsonant(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }else{
            if hanguleState.inputSecondFinalConsonant(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }
    }
    
    private func removeKeyPressed(){
        if source.length <= 0 {
            return
        }
        
        if hanguleState.state == .TURN_INIT_SOUND || hanguleState.isInitSound(){
            
            hanguleState.setStateInitSound()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            return
        }
        
        if hanguleState.isSingleVowel(){
            hanguleState.setStateVowel()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hanguleState.getLetterFormInitSound())
            return
        }
        
        if hanguleState.isDoubleVowel(){
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            
            hanguleState.clearLastVowel()
            source += String(hanguleState.getCompleteChar())
            return
        }
        
        if hanguleState.isSingleFinalConsonant(){
            hanguleState.clearFinalConsonant()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hanguleState.getCompleteChar())
            return
        }else if hanguleState.isFull(){
            hanguleState.clearLastFinalConsonant()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hanguleState.getCompleteChar())
        }
    }
}
