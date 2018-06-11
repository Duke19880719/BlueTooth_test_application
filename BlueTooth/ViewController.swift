//
//  ViewController.swift
//  BlueTooth
//
//  Created by 江培瑋 on 2017/8/5.
//  Copyright © 2017年 江培瑋. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth
import AVKit
import AVFoundation

class ViewController: UIViewController ,CBCentralManagerDelegate,CBPeripheralDelegate {

  
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var uiview1: UIImageView!
    @IBOutlet weak var view1: UIView!
    
    var BTPeripheral:[CBPeripheral] = [] //  儲存掃瞄到的 peripheral 物件
    var BTIsConnectable: [Int] = [] //  儲存各個藍芽裝置是否可連線
    var BTRSSI:[NSNumber] = [] // 儲存各個藍芽裝置的訊號強度
    var myCenteralManager: CBCentralManager!
    var selectedPeripheral: CBPeripheral!
    
    var tempstring:String = ""
    var avplayer = AVPlayer()
    var avplayerviewcontroller = AVPlayerViewController()
    var playitem1:AVPlayerItem!
    
    var book_value:String = ""
    var bookarray:[[String]] = [["002311517000000100000000000","IMG_0023"],["00231817000000100000000000","IMG_0022"],["002311017000000100000000000","IMG_0021"]]
    
    var DOS_DONTS:[[String]] =
        [["00323517000000100000000000","https://goo.gl/pw5ddt"],
         ["00323617000000100000000000","https://goo.gl/9izmXB"],
         ["00323717000000100000000000","https://goo.gl/geJNqC"]]
    var READ_AND_REAT:[[String]] =
        [["00323517000000100000000000","https://goo.gl/RCFspR"],
         ["00323617000000100000000000","https://goo.gl/WZTfrH"],
         ["00324717000000100000000000","https://goo.gl/5fYbn3"]]//"00231817000000100000000000","IMG_0022"
    var MACH_MAGIC:[[String]] =
        [["00325217000000100000000000","https://goo.gl/qWpWaZ"],
         ["00325317000000100000000000","https://goo.gl/BkJbdA"],
         ["00325417000000100000000000","https://goo.gl/Tgq7Pw"],
         ["00325517000000100000000000","https://goo.gl/eALQSP"]]
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // textview1.layer.borderColor = UIColor(red:100/255 ,green:100/255,blue:0,alpha:1).cgColor
        //textview1.layer.borderWidth = CGFloat(Float(1.0))
        myCenteralManager = CBCentralManager(delegate: self, queue: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOn:
            tempstring=tempstring+"BlueTooth ON\n"
          //  textview1.text=tempstring
        case CBManagerState.poweredOff:
            tempstring=tempstring+"BlueTooth OFF\n"
           // textview1.text=tempstring
        case CBManagerState.resetting:
            tempstring=tempstring+"BlueTooth RESSTING\n"
         //   textview1.text=tempstring
        case CBManagerState.unknown:
            tempstring=tempstring+"BlueTooth UNKNOW\n"
          //  textview1.text=tempstring
        case CBManagerState.unauthorized:
            tempstring=tempstring+"BlueTooth UNAUTHORIZED\n"
         //   textview1.text=tempstring
        case CBManagerState.unsupported:
            tempstring=tempstring+"BlueTooth UNSUPPORTED\n"
          //  textview1.text=tempstring
        }
    }
    
    
  
    @objc public func stopScan(){
        myCenteralManager!.stopScan()
        SearchBT.titleLabel?.text = "Scan"
        SearchBT.isEnabled = true
    }
    
    @IBOutlet weak var SearchBT: UIButton!
  //  weak var textview1: UITextView!
    
    @IBAction func SearchBTAction(_ sender: Any) {
        tempstring=""
        SearchBT.isEnabled = false
        SearchBT.titleLabel?.text = "Scanning"
        BTPeripheral.removeAll(keepingCapacity: false)
        BTRSSI.removeAll(keepingCapacity: false)
        BTIsConnectable.removeAll(keepingCapacity: false)
        myCenteralManager.scanForPeripherals(withServices: nil, options: nil)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.stopScan), userInfo: nil, repeats: false)
        }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
       {
        /*BTPeripheral.append(peripheral)
        BTRSSI.append(RSSI)
        BTIsConnectable.append(Int((advertisementData[CBAdvertisementDataIsConnectable]! as AnyObject).description)!)
        label2.text = String(BTIsConnectable.count)
        for i in 0...BTIsConnectable.count-1 {
            tempstring = tempstring + "\(BTPeripheral[i])\n\(BTIsConnectable[i])\n\(BTRSSI[i])\n\n"
        }
        textview1.text = tempstring
        print("\(peripheral)/n\(RSSI)/n\(CBAdvertisementDataIsConnectable)")*/
            if peripheral.name == "LBII_5E3584"{
            self.selectedPeripheral = peripheral;
            self.myCenteralManager = central;
            central.connect(self.selectedPeripheral, options: nil)
           // tempstring=tempstring+"\(self.selectedPeripheral)\n";
           // textview1.text = tempstring
            }
        }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       // tempstring=tempstring+"\(central)\n"
       // tempstring=tempstring+"\(peripheral)\n"
       // textview1.text = tempstring
        //关闭扫描
        self.myCenteralManager.stopScan()
        self.selectedPeripheral.delegate = self
        self.selectedPeripheral.discoverServices(nil)
       // print("扫描服务...");
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //print("---发现服务调用次方法-")
        
        for s in peripheral.services!{
            peripheral.discoverCharacteristics(nil, for: s)
          //  print(s.uuid.uuidString)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //print("----發現特征------")
        for c in service.characteristics! {
           if c.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"{
            peripheral.setNotifyValue(true, for: c)
           }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("----didUpdateValueForCharacteristic---")
        
        if characteristic.uuid.uuidString ==  "6E400003-B5A3-F393-E0A9-E50E24DCCA9E" {
           var array = [UInt8](characteristic.value!)
            for e in 0...array.count-1 {
                tempstring = tempstring + "\(array[e])"
            }
          
                for i in 0...2
                {
                    if tempstring == String(describing: bookarray[i][0])
                    {
                    book_value = bookarray[i][0]
                    uiview1.image =  UIImage(named:bookarray[i][1])
                        if avplayer.rate>=0{
                            avplayer.pause()
                            dismiss(animated: true, completion: nil)
                        }
                    playitem1=nil
                    }
                }
            
          if book_value == "002311017000000100000000000"
          {
                for z in 0...2
                {
                    if tempstring == DOS_DONTS[z][0]
                    {
                        movieplay(urlpath: DOS_DONTS[z][1])
                    }
                }
              }
           else if book_value == "00231817000000100000000000"
            {
                for z in 0...2
                {
                    if tempstring == READ_AND_REAT[z][0]
                    {
                        movieplay(urlpath: READ_AND_REAT[z][1])
                    }
                }
            }
            else if book_value == "002311517000000100000000000"
            {
                for z in 0...3
                {
                    if tempstring == MACH_MAGIC[z][0]
                    {
                        movieplay(urlpath: MACH_MAGIC[z][1])
                    }
                }
            }
           
            print(tempstring)
            tempstring = ""
         
        }
        
    }
    func movieplay(urlpath:String){
        let sourceurl = NSURL(string: urlpath)
        
        if sourceurl != nil && playitem1==nil
        {
            playitem1 = AVPlayerItem(url:sourceurl! as URL)
           // uiview1.isUserInteractionEnabled=false
            //AVPlayer 用於影片操作的物件，但是無法顯示視頻，需加入到avplayerviewcontroller or playerLayer，宣告一個avplayer物件，並給他一個網路資源位址
            avplayer = AVPlayer(playerItem: playitem1)
            //將avplayer 加入到avplayerviewcontroller
            avplayerviewcontroller.player=avplayer
           // avplaylayer=AVPlayerLayer(player:avplayer)
            //產生一個avplayerviewcontroller 畫面並執行
            self.present(avplayerviewcontroller, animated: true){
            self.avplayerviewcontroller.player!.play()
        
           }
        }
        else if avplayer.rate>=0
        {
            avplayer.pause()
            playitem1 = AVPlayerItem(url:sourceurl! as URL)
            avplayer.replaceCurrentItem(with: playitem1)
            self.avplayerviewcontroller.player!.play()
        }
        
    }
    



}
