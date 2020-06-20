//
//  MainViewController.swift
//  hitit-beaconFeasibilityTesting
//
//  Created by Yu Juno on 2020/06/20.
//  Copyright © 2020 hitit. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class MainViewController:UIViewController {
	
	lazy var startButton:UIButton = {
		let bt = UIButton(type: .system)
		bt.setTitle("Start", for: .normal)
		bt.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
		return bt
	}()
	
	lazy var stopButton:UIButton = {
		let bt = UIButton(type: .system)
		bt.setTitle("Stop", for: .normal)
		bt.addTarget(self, action: #selector(handleStopButton), for: .touchUpInside)
		return bt
	}()
	
	let beaconStatusLabel:UILabel = {
		let lb = UILabel()
		lb.text = ""
		lb.textAlignment = .center
		return lb
	}()
	
	var localBeacon: CLBeaconRegion!
	var beaconPeripheralData: NSDictionary!
	var peripheralManager: CBPeripheralManager!
	let localBeaconUUID:String = "0AC9518F-7BC5-4B12-908D-CBBD13EC2DDB"
	let localBeaconMajor: CLBeaconMajorValue = 1178
	let localBeaconMinor: CLBeaconMinorValue = 011
	let identifier = "Hitit.Beacon.Feasibility.Testing"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setup()
		addViews()
		setConstraints()
		stopButton.isHidden = true
		beaconStatusLabel.text = "OFF"
	}
	
	func setup() {
		
	}
	
	func addViews() {
		view.addSubview(startButton)
		view.addSubview(stopButton)
		view.addSubview(beaconStatusLabel)
	}
	
	func setConstraints() {
		startButtonConstraints()
		stopButtonConstraints()
		beaconStatusLabelConstraints()
	}
	
	func startButtonConstraints() {
		startButton.translatesAutoresizingMaskIntoConstraints = false
		startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	func stopButtonConstraints() {
		stopButton.translatesAutoresizingMaskIntoConstraints = false
		stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10).isActive = true
		stopButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	func beaconStatusLabelConstraints() {
		beaconStatusLabel.translatesAutoresizingMaskIntoConstraints = false
		beaconStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		beaconStatusLabel.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 10).isActive = true
		beaconStatusLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		beaconStatusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	@objc func handleStartButton() {
		initLocalBeacon()
		startButton.isHidden = true
		stopButton.isHidden = false
		beaconStatusLabel.text = ""
	}
	
	@objc func handleStopButton() {
		stopLocalBeacon()
		startButton.isHidden = false
		stopButton.isHidden = true
	}
	
	func initLocalBeacon() {
		if localBeacon != nil {
			stopLocalBeacon()
		}
		let uuid = UUID(uuidString: localBeaconUUID)!
		localBeacon = CLBeaconRegion(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: identifier)
		beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
		peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
	}
	
	func stopLocalBeacon() {
		peripheralManager.stopAdvertising()
		peripheralManager = nil
		beaconPeripheralData = nil
		localBeacon = nil
	}
}


extension MainViewController:CBPeripheralManagerDelegate {
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		if peripheral.state == .poweredOn {
			peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
		} else if peripheral.state == .poweredOff {
			peripheralManager.stopAdvertising()
		}
	}
}
