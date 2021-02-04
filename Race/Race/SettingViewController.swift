//
//  SecondViewController.swift
//  Race
//
//  Created by Oleg on 5/9/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imageCar: UIImageView!
    @IBOutlet weak var labelInformation: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonSkill: UIButton!
    @IBOutlet weak var buttonTypeAuto: UIButton!
    
    //MARK: - Var
    var picketView: UIPickerView!
    var dataDifficulty = true
    var gamer: Gamer? = nil
    var player: AVAudioPlayer?
    
    //MARK: - Let
    let shared = Manager.shared
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createSettingVC()
        shared.load()
        playSound()
    }
    
    //MARK: - Actions
    @IBAction func buttonTypeAuto(_ sender: UIButton) {
        labelInformation.isHidden = true
        view.endEditing(true)
        deletePicker()
        dataDifficulty = false
        createViewCar(name: self.gamer!.nameCar!)
        creatPicketView()
    }
    
    @IBAction func buttonSkill(_ sender: UIButton) {
        labelInformation.isHidden = true
        view.endEditing(true)
        deletePicker()
        dataDifficulty = true
        creatPicketView()
    }
    
    @IBAction func buttonStart(_ sender: UIButton) {
        if self.gamer?.name == nil || self.gamer?.name == "" {
            labelInformation.isHidden = false
        } else {
            self.gamer?.difficulty = 1
            guard let VC = storyboard?.instantiateViewController(identifier: "RaceViewController") as? RaceViewController else {return}
            VC.gamer = self.gamer
            VC.delegate = self
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func buttonResults(_ sender: UIButton) {
        guard let VC = storyboard?.instantiateViewController(identifier: "ListVictoryViewController") as? ListVictoryViewController else {return}
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    @IBAction func switchMusic(_ sender: UISwitch) {
        if sender.isOn {
            player?.play()
        }else{
            player?.stop()
        }
    }
    
    //MARK: - Flow functions
    private func playSound() {
        guard  let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard player != nil else {return}
            
        } catch {
            print(error)
        }
        
    }
    private func createSettingVC(){
        if gamer != nil {
            self.textField.text = gamer?.name
            self.imageCar.image = UIImage(named: (gamer?.nameCar)!)
            self.imageCar.isHidden = false
        } else {
            self.gamer = Gamer(name: nil, nameCar: self.shared.arrayType[0])
            self.imageCar.image = UIImage(named: self.gamer!.nameCar!)
        }
        self.imageCar.layer.cornerRadius = 15
        self.imageCar.clipsToBounds = true
        self.labelInformation.layer.cornerRadius = 10
        self.labelInformation.clipsToBounds = true
        self.labelInformation.isHidden = true
        self.textField.delegate = self
    }
    
    private func deletePicker() {
        guard let picker = self.picketView else {return}
        picker.removeFromSuperview()
    }
    
    private func creatPicketView() {
        picketView = UIPickerView()
        picketView.translatesAutoresizingMaskIntoConstraints = false
        
        picketView.layer.cornerRadius = 5
        picketView.backgroundColor = .white
        picketView.dataSource = self
        picketView.delegate = self
        view.addSubview(picketView)
        if dataDifficulty {
            picketView.leadingAnchor.constraint(equalTo: buttonSkill.trailingAnchor).isActive = true
            picketView.centerYAnchor.constraint(equalTo: buttonSkill.centerYAnchor).isActive = true
            picketView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            picketView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }else{
            picketView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            picketView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            picketView.centerXAnchor.constraint(equalTo: buttonTypeAuto.centerXAnchor).isActive = true
            picketView.topAnchor.constraint(equalTo: buttonTypeAuto.bottomAnchor).isActive = true
        }
    }
    
    private func createViewCar(name: String){
        self.imageCar.image = UIImage(named: name)
    }
}

//MARK: - Extension UIPickerViewDataSource
extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if dataDifficulty {
            return shared.arrayDifficulty.count
        } else {
            return shared.arrayType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dataDifficulty {
            return shared.arrayDifficulty[row]
        } else {
            return shared.arrayType[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dataDifficulty {
            let score = shared.arrayDifficulty[row]
            self.gamer?.difficulty = Double(score)!
        } else {
            let name = shared.arrayType[row]
            self.gamer?.nameCar = name
            createViewCar(name: name)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelInformation.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.gamer?.name = textField.text!
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.gamer?.name = textField.text!
        return true
    }
}

extension SettingViewController: ListVictoryViewControllerDelegate {
    func setGamer(object: Gamer) {
        self.gamer = object
        self.textField.text = self.gamer?.name
        self.imageCar.image = UIImage(named: self.gamer!.nameCar!)
    }
}
// MARK: - extension

extension SettingViewController: RaceViewControllerDelegate {
    func playing(info: Bool) {
        if info == false {
            self.player?.stop()
        }
    }
    
}
