//
//  ViewController.swift
//  Tsumi_Ei_rev0
//
//  Created by Yuji Miyano on 2015/12/19.
//  Copyright © 2015年 Yuji Miyano. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// Player
var audioPlayer: AVAudioPlayer?
// Counter
var count = 0
// flags
var isAceAnswered = false
var isActAnswered = false
var isApeAnswered = false
var isAteAnswered = false
var isCapAnswered = false
var isCatAnswered = false
var isEatAnswered = false
var isPetAnswered = false
var isTapAnswered = false
var isTeaAnswered = false
var isCongratsShowed = false
var isPerfectShowed = false
var strBlock = "none"
var isSoundPlayed = false
var isButtonChecked = false  // ボタン連打防止
var isValuePIOOdd = false  // ボタン連打防止

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
  
  // For BLE
  var isScanning = false
  var centralManager:CBCentralManager!
  var peripheral:CBPeripheral!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // CBCentralManagerを初期化
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
    
    // カウンタ更新
    lbl_counter.text = "\(count)"
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    print("HomeViewControllerのviewDidAppearが呼ばれた")
    isSoundPlayed = false
    isValuePIOOdd = false
  }
  
  // =========================================================================
  // MARK: CBCentralManagerDelegate
  
  // セントラルマネージャの状態が変化すると呼ばれる
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    
    print("state: \(central.state)")
  }
  
  // ペリフェラルを発見すると呼ばれる
  func centralManager(_ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String : Any],
    rssi RSSI: NSNumber)
  {
    print("発見したBLEデバイス: \(peripheral)")
    
    if peripheral.name != nil { // nilを検出した場合は先に進まない
      
//      if peripheral.name?.hasPrefix("konashi") == true {
//      if peripheral.name?.hasPrefix("konashi2-f017a8") == true {  // idを指定したkonashiしか接続しない。
//      if peripheral.name?.hasPrefix("konashi2-f01a78") == true {
//      if peripheral.name?.hasPrefix("konashi2-f029f4") == true {
      if peripheral.name?.hasPrefix("konashi2-f02c4d") == true {
//      if peripheral.name?.hasPrefix("konashi2-f02a00") == true {
//      if peripheral.name?.hasPrefix("konashi2-f02b3e") == true {
//      if peripheral.name?.hasPrefix("konashi2-f02a03") == true {
      
        self.peripheral = peripheral
        
        // 接続開始
        self.centralManager.connect(self.peripheral, options: nil)
      }
    }
  }
  
  // ペリフェラルへの接続が成功すると呼ばれる
  func centralManager(_ central: CBCentralManager,
    didConnect peripheral: CBPeripheral)
  {
    print("接続成功！")
    
    // サービス探索結果を受け取るためにデリゲートをセット
    peripheral.delegate = self
    
    // サービス探索開始
    peripheral.discoverServices(nil)
  }
  
  // ペリフェラルへの接続が失敗すると呼ばれる
  func centralManager(_ central: CBCentralManager,
    didFailToConnect peripheral: CBPeripheral,
    error: Error?)
  {
    print("接続失敗・・・")
  }
  
  // =========================================================================
  // MARK:CBPeripheralDelegate
  
  // サービス発見時に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
    if (error != nil) {
      print("エラー: \(error)")
      return
    }
    
    if !(peripheral.services?.count > 0) {
      print("no services")
      return
    }
    
    let services = peripheral.services!
    
    print("\(services.count) 個のサービスを発見！ \(services)")
    
    for service in services {
      
      // キャラクタリスティック探索開始
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  // キャラクタリスティック発見時に呼ばれる
  func peripheral(_ peripheral: CBPeripheral,
    didDiscoverCharacteristicsFor service: CBService,
    error: Error?)
  {
    if (error != nil) {
      print("エラー: \(error)")
      return
    }
    
    if !(service.characteristics?.count > 0) {
      print("no characteristics")
      return
    }
    
    let characteristics = service.characteristics!
    
    for characteristic in characteristics {
      
      // konashi の PIO_INPUT_NOTIFICATION キャラクタリスティック
      if characteristic.uuid.isEqual(CBUUID(string: "229B3003-03FB-40DA-98A7-B0DEF65C2D4B")) {  // konashi 1.0では3003
        
        // 更新通知受け取りを開始する
        peripheral.setNotifyValue(
          true,
          for: characteristic)
      }
    }
  }
  
  // Notify開始／停止時に呼ばれる
  func peripheral(_ peripheral: CBPeripheral,
    didUpdateNotificationStateFor characteristic: CBCharacteristic,
    error: Error?)
  {
    if error != nil {
      
      print("Notify状態更新失敗...error: \(error)")
    }
    else {
      print("Notify状態更新成功！characteristic UUID:\(characteristic.uuid), isNotifying: \(characteristic.isNotifying)")
    }
  }
  
  // データ更新時に呼ばれる
  func peripheral(_ peripheral: CBPeripheral,
    didUpdateValueFor characteristic: CBCharacteristic,
    error: Error?)
  {
    var valuePIO: NSInteger = 0
    
    if error != nil {
      print("データ更新通知エラー: \(error)")
      return
    }
    
    print("データ更新！ characteristic UUID: \(characteristic.uuid), value: \(characteristic.value)")
    
    (characteristic.value! as NSData).getBytes(&valuePIO, length: MemoryLayout<NSInteger>.size) // NSData -> NSIntegerに変換
    
    print("データ更新！ valuePIO: \(valuePIO)")
    
    if isValuePIOOdd == false {
      switch valuePIO {
      case 3 :
        strBlock = "ace"
        if isAceAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isAceAnswered = true
        performSegue(withIdentifier: "ace",sender: nil)
        print("ace segue")
        
        break
        
      case 5 :
        strBlock = "act"
        if isActAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isActAnswered = true
        performSegue(withIdentifier: "act",sender: nil)
        
        break
        
      case 7 :
        strBlock = "ape"
        if isApeAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isApeAnswered = true
        performSegue(withIdentifier: "ape",sender: nil)
        
        break
        
      case 9 :
        strBlock = "ate"
        if isAteAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isAteAnswered = true
        performSegue(withIdentifier: "ate",sender: nil)
        
        break
        
      case 11 :
        strBlock = "cap"
        if isCapAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isCapAnswered = true
        performSegue(withIdentifier: "cap",sender: nil)
        
        break
        
      case 13 :
        strBlock = "cat"
        if isCatAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isCatAnswered = true
        performSegue(withIdentifier: "cat",sender: nil)
        
        break
        
      case 15 :
        strBlock = "eat"
        if isEatAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isEatAnswered = true
        performSegue(withIdentifier: "eat",sender: nil)
        print("eat segue")
        break
        
      case 17 :
        strBlock = "pet"
        if isPetAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isPetAnswered = true
        performSegue(withIdentifier: "pet",sender: nil)
        
        break
        
      case 19 :
        strBlock = "tap"
        if isTapAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isTapAnswered = true
        performSegue(withIdentifier: "tap",sender: nil)
        
        break
        
      case 21 :
        strBlock = "tea"
        if isTeaAnswered == false {
          count += 1
          lbl_counter.text = "\(count)"
        }
        isTeaAnswered = true
        performSegue(withIdentifier: "tea",sender: nil)
        
        break
        
      case 29 :
        strBlock = "NG"
        performSegue(withIdentifier: "NG",sender: nil)
        break
        
      default :
  //        if strBlock != "none" { // PIOの状態が変わったら画面が戻る
  //          self.dismissViewControllerAnimated(true, completion: nil)
  //        }
        break
      }
    }
    if valuePIO % 2 != 0 {
      isValuePIOOdd = true
    }
    print(isValuePIOOdd)
  }
  
  // =========================================================================
  // MARK: Actions
  
  @IBOutlet weak var lbl_counter: UILabel!
  
  
  @IBAction func scanBtnTapped(_ sender: UIButton) {
    
    if !isScanning {
      
      isScanning = true
      
      self.centralManager!.scanForPeripherals(withServices: nil, options: nil)
      
      sender.setTitle("つながない", for: UIControlState())
    }
    else {
      
      self.centralManager!.stopScan()
      
      sender.setTitle("つみきにつなぐ", for: UIControlState())
      
      isScanning = false
    }
  }

  @IBAction func resetCount(_ sender: AnyObject) {
    count = 0;
    lbl_counter.text = "\(count)"
    isAceAnswered = false
    isActAnswered = false
    isApeAnswered = false
    isAteAnswered = false
    isCapAnswered = false
    isCatAnswered = false
    isEatAnswered = false
    isPetAnswered = false
    isTapAnswered = false
    isTeaAnswered = false
    isCongratsShowed = false
    isPerfectShowed = false
    strBlock = "none"
    isSoundPlayed = false
    isButtonChecked = false
  }
  
  // =========================================================================
  // デバッグ用のボタン 本番不使用
  @IBAction func showAce(_ sender: AnyObject) {
    strBlock = "ace"
    if isAceAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isAceAnswered = true
  }

  @IBAction func showAct(_ sender: AnyObject) {
    strBlock = "act"
    if isActAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isActAnswered = true
  }
  
  @IBAction func showApe(_ sender: AnyObject) {
    strBlock = "ape"
    if isApeAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isApeAnswered = true
  }
  
  @IBAction func showAte(_ sender: AnyObject) {
    strBlock = "ate"
    if isAteAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isAteAnswered = true
  }
  
  @IBAction func showCap(_ sender: AnyObject) {
    strBlock = "cap"
    if isCapAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isCapAnswered = true
  }
  
  @IBAction func showCat(_ sender: AnyObject) {
    strBlock = "cat"
    if isCatAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isCatAnswered = true
  }

  @IBAction func showEat(_ sender: AnyObject) {
    strBlock = "eat"
    if isEatAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isEatAnswered = true
  }
  
  @IBAction func showPet(_ sender: AnyObject) {
    strBlock = "pet"
    if isPetAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isPetAnswered = true
  }
  
  @IBAction func showTap(_ sender: AnyObject) {
    strBlock = "tap"
    if isTapAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isTapAnswered = true
  }
  
  @IBAction func showTea(_ sender: AnyObject) {
    strBlock = "tea"
    if isTeaAnswered == false {
      count += 1
      lbl_counter.text = "\(count)"
    }
    isTeaAnswered = true
  }
  
  @IBAction func showNG(_ sender: AnyObject) {
    strBlock = "ng"
    soundPlay("不正解", fileType: "wav")
  }
  
  // =========================================================================
  
  @IBAction func comeHome(_ segue: UIStoryboardSegue) {
  }
}

// Sound play function
func soundPlay(_ fileName: String, fileType: String){
  if let url = Bundle.main.url(forResource: fileName, withExtension: fileType) {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
    } catch {
      // Player作成失敗
      
      fatalError("Failed to initialize a player.")
    }
    
  } else {
    // urlがnilなので再生できない
    
    fatalError("Url is nil.")
  }
  // 再生
  if let player = audioPlayer {
    player.play()
  }
}
