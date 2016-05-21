//
//  SenStickUUIDs.swift
//  SenStickSDK
//
//  Created by AkihiroUehara on 2016/03/16.
//  Copyright © 2016年 AkihiroUehara. All rights reserved.
//

import Foundation
import CoreBluetooth


public struct SenStickUUIDs
{
    // ベースUUID
    public static let baseUUIDString = "F0000000-0451-4000-B000-000000000000"
    public static let baseUUID:CBUUID = {return SenStickUUIDs.createSenstickUUID(0x0000)}()
    // UUID生成メソッド
    public static func createSenstickUUID(uuid:UInt16) -> CBUUID {
        return CBUUID.init(string: (SenStickUUIDs.baseUUIDString as NSString).stringByReplacingCharactersInRange(NSMakeRange(4, 4), withString: NSString(format: "%04x", uuid) as String))
    }
    public static func getShortUUID(uuid:CBUUID) -> UInt16 {
        // UUIDをバイト配列にして、16ビット短縮UUID部分を取り出す
        var buf = [UInt8](count: 16, repeatedValue: 0)
        uuid.data.getBytes(&buf, length: buf.count)
        return UInt16.unpack(buf[2..<4], byteOrder: .BigEndian)!
        /*
        // UUIDをバイト配列にして、16ビット短縮UUID部分を取り出す
        var buf = [UInt8](count: 16, repeatedValue: 0)
        uuid.data.getBytes(&buf, length: buf.count)
        let shortuuid = UInt16.unpack(buf[2..<4], byteOrder: .BigEndian)

        // 短縮UUID部分を0クリアして、ベースUUIDと比較する
        buf[2] = 0
        buf[3] = 0

        var baseuuid_data = [UInt8](count: 16, repeatedValue: 0)
        baseUUID.data.getBytes(&baseuuid_data, length: baseuuid_data.count)
        if baseuuid_data == buf {
            return shortuuid
        } else {
            return nil
        }*/
    }

    // アドバタイジングするサービスUUID (コントロールサービス)
    public static let advertisingServiceUUID:CBUUID    = ControlServiceUUID
    
    // control service
    public static let ControlServiceUUID:CBUUID        = {return SenStickUUIDs.createSenstickUUID(0x2000)}()
    public static let StatusCharUUID:CBUUID            = {return SenStickUUIDs.createSenstickUUID(0x7000)}()
    public static let ControlPointCharUUID:CBUUID      = {return SenStickUUIDs.createSenstickUUID(0x7001)}()
    public static let AvailableLogCountCharUUID:CBUUID = {return SenStickUUIDs.createSenstickUUID(0x7002)}()
    public static let DateTimeCharUUID:CBUUID          = {return SenStickUUIDs.createSenstickUUID(0x7003)}()
    public static let AbstractCharUUID:CBUUID          = {return SenStickUUIDs.createSenstickUUID(0x7004)}()
    
    // メタデータ読み出しサービス
    public static let MetaDataServiceUUID:CBUUID    = {return SenStickUUIDs.createSenstickUUID(0x2001)}()
    public static let TargetLogIDCharUUID:CBUUID    = {return SenStickUUIDs.createSenstickUUID(0x7010)}()
    public static let TargetDateTimeCharUUID:CBUUID = {return SenStickUUIDs.createSenstickUUID(0x7011)}()
    public static let TargetAbstractCharUUID:CBUUID = {return SenStickUUIDs.createSenstickUUID(0x7012)}()
    
    // センサーのサービスのベースUUID。下1桁はセンサータイプのrawValueがはいります。
    public static let sensorServiceBaseUUID:UInt16           = 0x2100
    public static let sensorSettingCharBaseUUID:UInt16       = 0x7100
    public static let sensorRealTimeDataCharBaseUUID:UInt16  = 0x7200
    public static let sensorLogIDCharBaseUUID:UInt16         = 0x7300
    public static let sensorLogMetaDataCharBaseUUID:UInt16   = 0x7400
    public static let sensorLogSensorDataCharBaseUUID:UInt16 = 0x7500
    
    // センサのサービスのUUID生成
    public static func createSenstickSensorServiceUUID(sensorType:SenStickSensorType) -> CBUUID {
        return SenStickUUIDs.createSenstickUUID(sensorServiceBaseUUID | UInt16(sensorType.rawValue))
    }
    // Senstickのセンサデバイスの、キャラクタリスティクスのUUIDの配列、を返します。
    public static func createSenstickSensorCharacteristicUUIDs(sensorType: SenStickSensorType) -> [CBUUID]
    {
        return [
            createSenstickUUID(sensorSettingCharBaseUUID | UInt16(sensorType.rawValue)),
            createSenstickUUID(sensorRealTimeDataCharBaseUUID | UInt16(sensorType.rawValue)),
            createSenstickUUID(sensorLogIDCharBaseUUID | UInt16(sensorType.rawValue)),
            createSenstickUUID(sensorLogMetaDataCharBaseUUID | UInt16(sensorType.rawValue)),
            createSenstickUUID(sensorLogSensorDataCharBaseUUID | UInt16(sensorType.rawValue))
        ]
    }

    // センサごとのサービスのUUID
    public static let accelerationSensorServiceUUID:CBUUID = {return SenStickUUIDs.createSenstickSensorServiceUUID(SenStickSensorType.AccelerationSensor) }()

    // デバイスが持つべき、サービスUUIDがキー、キャラクタリスティクスの配列、の辞書を返します。
    public static let SenStickServiceUUIDs: [CBUUID: [CBUUID]] =
        [ ControlServiceUUID   : [StatusCharUUID, ControlPointCharUUID, AvailableLogCountCharUUID, DateTimeCharUUID, AbstractCharUUID],
          MetaDataServiceUUID  : [TargetLogIDCharUUID, TargetDateTimeCharUUID, TargetAbstractCharUUID],
          {return SenStickUUIDs.createSenstickUUID(sensorServiceBaseUUID | UInt16(SenStickSensorType.AccelerationSensor.rawValue)) }() :
            { return SenStickUUIDs.createSenstickSensorCharacteristicUUIDs(SenStickSensorType.AccelerationSensor ) }()
    ]
}