//
//  ViewController_words.swift
//  Tsumi_Ei_rev2
//
//  Created by Yuji Miyano on 2016/01/01.
//  Copyright © 2016年 Yuji Miyano. All rights reserved.
//


import UIKit

class ViewController_words: UIViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if strBlock != "NG" && isSoundPlayed == false {
      // Play sound
      soundPlay("正解", fileType: "wav")
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print(strBlock)
    
    switch strBlock {
    case "ace" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.acePlay), userInfo: nil, repeats: false)
//        soundPlay("ACE", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "act" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.actPlay), userInfo: nil, repeats: false)
//        soundPlay("ACT", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "ape" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.apePlay), userInfo: nil, repeats: false)
//        soundPlay("APE", fileType: "mp3")
        isSoundPlayed = true
      }
      break

    case "ate" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.atePlay), userInfo: nil, repeats: false)
//        soundPlay("ATE", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "cap" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.capPlay), userInfo: nil, repeats: false)
//        soundPlay("CAP", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "cat" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.catPlay), userInfo: nil, repeats: false)
//        soundPlay("CAT", fileType: "mp3")
        isSoundPlayed = true
      }
      break
    
    case "eat" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.eatPlay), userInfo: nil, repeats: false)
//        soundPlay("EAT", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "pet" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.petPlay), userInfo: nil, repeats: false)
//        soundPlay("PET", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "tap" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.tapPlay), userInfo: nil, repeats: false)
//        soundPlay("TAP", fileType: "mp3")
        isSoundPlayed = true
      }
      break
      
    case "tea" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.teaPlay), userInfo: nil, repeats: false)
//        soundPlay("TEA", fileType: "mp3")
        isSoundPlayed = true
      }
      break

    case "NG" :
      if isSoundPlayed == false {
        Timer.scheduledTimer(timeInterval: 0.5,target:self,selector:#selector(ViewController_words.falsePlay), userInfo: nil, repeats: false)
//        soundPlay("不正解", fileType: "wav")
        isSoundPlayed = true
      }
      break
      
    default:
      break
      
    }
    
    // 7問正解でCongrats画面
    if count == 7 && isCongratsShowed == false {
      Timer.scheduledTimer(timeInterval: 3.0,target:self,selector:#selector(ViewController_words.transitionCongrats), userInfo: nil, repeats: false)
      isCongratsShowed = true
      Timer.scheduledTimer(timeInterval: 3.0,target:self,selector:#selector(ViewController_words.specialPlay), userInfo: nil, repeats: false)
//      soundPlay("Special", fileType: "mp3")
      Timer.scheduledTimer(timeInterval: 8.5,target:self,selector:#selector(ViewController_words.transitionBack), userInfo: nil, repeats: false)
      Timer.scheduledTimer(timeInterval: 9.0,target:self,selector:#selector(ViewController_words.transitionBack), userInfo: nil, repeats: false)
    }
    // 10問正解でPerfect画面
    else if count == 10 && isPerfectShowed == false {
      Timer.scheduledTimer(timeInterval: 3.0,target:self,selector:#selector(ViewController_words.transitionPerfect), userInfo: nil, repeats: false)
      isPerfectShowed = true
      Timer.scheduledTimer(timeInterval: 3.0,target:self,selector:#selector(ViewController_words.specialPlay), userInfo: nil, repeats: false)
//      soundPlay("Special", fileType: "mp3")
      Timer.scheduledTimer(timeInterval: 8.5,target:self,selector:#selector(ViewController_words.transitionBack), userInfo: nil, repeats: false)
      Timer.scheduledTimer(timeInterval: 9.0,target:self,selector:#selector(ViewController_words.transitionBack), userInfo: nil, repeats: false)
    }
    // 一定時間後にホーム画面に戻る
    else {
      Timer.scheduledTimer(timeInterval: 3.5,target:self,selector:#selector(ViewController_words.transitionBack), userInfo: nil, repeats: false)
    }
    
  }
  
  func acePlay(){
    soundPlay("ACE", fileType: "mp3")
  }
  
  func actPlay(){
    soundPlay("ACT", fileType: "mp3")
  }
  
  func apePlay(){
    soundPlay("APE", fileType: "mp3")
  }
  
  func atePlay(){
    soundPlay("ATE", fileType: "mp3")
  }
  
  func capPlay(){
    soundPlay("CAP", fileType: "mp3")
  }
  
  func catPlay(){
    soundPlay("CAT", fileType: "mp3")
  }
  
  func eatPlay(){
    soundPlay("EAT", fileType: "mp3")
  }
  
  func petPlay(){
    soundPlay("PET", fileType: "mp3")
  }
  
  func tapPlay(){
    soundPlay("TAP", fileType: "mp3")
  }
  
  func teaPlay(){
    soundPlay("TEA", fileType: "mp3")
  }

  func falsePlay(){
    soundPlay("不正解", fileType: "wav")
  }

  func specialPlay(){
    soundPlay("Special", fileType: "mp3")
  }
  
  func transitionCongrats() {  // Congrats画面を表示する
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let next:UIViewController = storyboard.instantiateViewController(withIdentifier: "congrats") as UIViewController
    
    next.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    self.present(next, animated: true, completion: nil)
  }
  
  func transitionPerfect() {  // Perfect画面を表示する
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let next:UIViewController = storyboard.instantiateViewController(withIdentifier: "perfect") as UIViewController
    
    next.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    self.present(next, animated: true, completion: nil)
  }

  func transitionBack() { // 前画面に戻る
    self.dismiss(animated: true, completion: nil)
  }
  
}
