//
//  LogReaderViewController.swift
//  SenStickViewer
//
//  Created by AkihiroUehara on 2016/06/26.
//  Copyright © 2016年 AkihiroUehara. All rights reserved.
//

import UIKit
import SenStickSDK

class LogReaderViewController: UITableViewController, SenStickDeviceDelegate {
    var device: SenStickDevice?
    var logID: UInt8?
    
    var accelerationDataModel:  AccelerationDataModel?
    var gyroDataModel:          GyroDataModel?
    var magneticFieldDataModel: MagneticFieldDataModel?
    var brightnessDataModel:    BrightnessDataModel?
    var uvDataModel:            UVDataModel?
    var humidityDataModel:      HumidityDataModel?
    var pressureDataModel:      PressureDataModel?
    
    // View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        accelerationDataModel  = AccelerationDataModel()
        gyroDataModel          = GyroDataModel()
        magneticFieldDataModel = MagneticFieldDataModel()
        brightnessDataModel    = BrightnessDataModel()
        uvDataModel            = UVDataModel()
        humidityDataModel      = HumidityDataModel()
        pressureDataModel      = PressureDataModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        device?.delegate = self
        setServices()
        startToReadLog(self.logID!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        device?.delegate = nil
    }

    // MARK: - SenStickDeviceDelegate
    
    func didServiceFound(sender: SenStickDevice)
    {
    }
    
    func didConnected(sender:SenStickDevice)
    {
    }
    
    func didDisconnected(sender:SenStickDevice)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // methods
    
    func setServices()
    {
        accelerationDataModel?.service  = device?.accelerationSensorService
        gyroDataModel?.service          = device?.gyroSensorService
        magneticFieldDataModel?.service = device?.magneticFieldSensorService
        brightnessDataModel?.service    = device?.brightnessSensorService
        uvDataModel?.service            = device?.uvSensorService
        humidityDataModel?.service      = device?.humiditySensorService
        pressureDataModel?.service      = device?.pressureSensorService
    }
    
    func startToReadLog(logid: UInt8)
    {
        accelerationDataModel?.startToReadLog(logid)
        gyroDataModel?.startToReadLog(logid)
        magneticFieldDataModel?.startToReadLog(logid)
        brightnessDataModel?.startToReadLog(logid)
        uvDataModel?.startToReadLog(logid)
        humidityDataModel?.startToReadLog(logid)
        pressureDataModel?.startToReadLog(logid)
    }
    
    // table view source/delegate
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let dataCell = cell as? SensorDataCellView
        dataCell?.iconButton?.userInteractionEnabled = false
        
        switch (indexPath.row) {
        case 0:
            accelerationDataModel?.cell    = dataCell
            dataCell?.iconButton?.enabled  = (accelerationDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (accelerationDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 1:
            gyroDataModel?.cell            = dataCell
            dataCell?.iconButton?.enabled  = (gyroDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (gyroDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 2:
            magneticFieldDataModel?.cell   = dataCell
            dataCell?.iconButton?.enabled  = (magneticFieldDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (magneticFieldDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 3:
            brightnessDataModel?.cell      = dataCell
            dataCell?.iconButton?.enabled  = (brightnessDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (brightnessDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 4:
            uvDataModel?.cell              = dataCell
            dataCell?.iconButton?.enabled  = (uvDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (uvDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 5:
            humidityDataModel?.cell        = dataCell
            dataCell?.iconButton?.enabled  = (humidityDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (humidityDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        case 6:
            pressureDataModel?.cell        = dataCell
            dataCell?.iconButton?.enabled  = (pressureDataModel?.service?.logMetaData?.availableSampleCount != 0)
            dataCell?.iconButton?.selected = (pressureDataModel?.service?.logMetaData?.availableSampleCount != 0)
            
        default: break
        }
    }
}

