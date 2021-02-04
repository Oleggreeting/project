//
//  AlbomViewController.swift
//  PhotoAlbom
//
//  Created by Oleg on 6/24/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class AlbomViewController: UIViewController {
    
    //MARK:- Var
    var collectionView: UICollectionView!
    var buttonRight: UIBarButtonItem!
    var item: Item?
    var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    var dictionaryItemsIsSelected: [IndexPath] = []
    
    //MARK:- Let
    let pickerImage = UIImagePickerController()
    let viewPin = ViewPin.instanceFromNib()
    let pin = "r"
    let shared = Manager.shared
    let myCell = "cell"
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Albom"
        pickerImage.delegate = self
        settingNavBar()
        shared.loadItems()
        createCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        
    }
    
    //MARK:- Flow functions
    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: myCell)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        constraints()
    }
    
    func constraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func settingNavBar() {
        let buttonLeft = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(choosePlaceForAdding(_:)))
        self.navigationItem.leftBarButtonItem = buttonLeft
        self.navigationItem.rightBarButtonItem = editButtonItem
        var items = [UIBarButtonItem]()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = self.view.frame.width / 2 - CGFloat(20)
        items.append(space)
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItems)))
        toolbarItems = items
        navigationController?.isToolbarHidden = true
    }
    
    @objc func removeItems(){
        for i in dictionaryItemsIsSelected {
            shared.arrayItems.remove(at: i.row)
        }
        collectionView.reloadData()
        dictionaryItemsIsSelected = []
        shared.saveItems()
        label.text = ""
    }
    
    @objc func choosePlaceForAdding(_ sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Where to get the photo?", message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.pickerImage.sourceType = .camera
            self.present(self.pickerImage, animated: true, completion: nil)
            
        }
        let actionFile = UIAlertAction(title: "File", style: .default) { (_) in
            self.pickerImage.sourceType = .photoLibrary
            self.present(self.pickerImage, animated: true, completion: nil)
        }
        
        let actioCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(actionFile)
        alert.addAction(actionCamera)
        alert.addAction(actioCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            navigationController?.isToolbarHidden = false
            collectionView.allowsMultipleSelection = true
        }else{
            navigationController?.isToolbarHidden = true
            collectionView.allowsMultipleSelection = false
        }
    }
    
    private func viewForPin() {
        viewPin.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        viewPin.textField.delegate = self
        viewPin.viewAlert.layer.cornerRadius = 15
        viewPin.viewAlert.clipsToBounds = true
        viewPin.labelWrongCode.isHidden = true
        viewPin.buttonOk.addTarget(self, action: #selector(checkPin), for: .touchUpInside)
        viewPin.buttonCancel.addTarget(self, action: #selector(removeKeypad), for: .touchUpInside)
        self.view.addSubview(viewPin)
    }
    
    @objc func checkPin() {
        if viewPin.textField.text == pin {
            viewPin.removeFromSuperview()
        } else {
            viewPin.labelWrongCode.isHidden = false
        }
    }
    
    @objc func removeKeypad() {
        viewPin.textField.text = nil
        viewPin.textField.resignFirstResponder()
    }
    
}

//MARK:- Extention UICollectionViewDataSource
extension AlbomViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shared.arrayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {return MyCell()}
        if let image = self.shared.loadImage(fileName: self.shared.arrayItems[indexPath.item].path!) {
            cell.lable.isHidden = !shared.arrayItems[indexPath.row].selected
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2 - 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isEditing{
            let cell = collectionView.cellForItem(at: indexPath) as? MyCell
            cell?.lable.isHidden = false
            dictionaryItemsIsSelected.append(indexPath)
            if dictionaryItemsIsSelected.count > 0 {
                self.label.text = " selected \(dictionaryItemsIsSelected.count) elements "
            } else {
                self.label.text = ""
            }
        } else {
            let item = self.shared.arrayItems[indexPath.row]
            let VC = PhotoViewController()
            VC.indexPath = indexPath
            VC.item = item
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MyCell
        cell?.lable.isHidden = true
        dictionaryItemsIsSelected.removeAll(where: {$0 == indexPath})
        if dictionaryItemsIsSelected.count > 0 {
            self.label.text = "selected \(dictionaryItemsIsSelected.count) elements"
        } else {
            self.label.text = ""
        }
    }
    
}

//MARK:- Extention UITextFieldDelegate
extension AlbomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- Extention UIImagePickerControllerDelegate
extension AlbomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            let item = Item()
            item.path = self.shared.saveImage(image: pickerImage)
            self.shared.arrayItems.append(item)
            self.shared.saveItems()
            self.collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
