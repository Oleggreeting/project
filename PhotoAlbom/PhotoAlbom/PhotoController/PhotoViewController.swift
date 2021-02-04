//
//  ViewController.swift
//  PhotoAlbom
//
//  Created by Oleg on 6/4/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: - Let
    let shared = Manager.shared
    
    //MARK:- Var
    var colletionView = BigGalleryCollectionView()
    var indexPath: IndexPath!
    var item: Item!
    var image = UIImage()
    var refresh: UIRefreshControl!
    var myButton: UIButton!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shared.loadItems()
        view.backgroundColor = .red
        title = item.dateStr
        settingView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK:- Flow function
    private func settingView() {
        self.view.backgroundColor = .black
        settingToolBar()
        createCollectionView()
    }
    private func settingToolBar() {
        self.navigationController?.isToolbarHidden = false
        
        var items = [UIBarButtonItem]()
        let width = CGFloat(self.view.frame.width / 3)
        let item1 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        item1.width = width
        items.append(item1)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = width
        items.append(space)
        
        self.myButton = UIButton(type: .custom)
        myButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        myButton.setBackgroundImage(UIImage(systemName: "heart"),for: .normal)
        myButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .selected)
        myButton.addTarget(self, action: #selector(heart(_:)), for: .touchUpInside)
        if item.like {
            myButton.isSelected = true
        }else{
            myButton.isSelected = false
        }
        let button = UIBarButtonItem(customView: myButton)
        items.append(button)
        items.append(space)
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trash)))
        toolbarItems = items
        
    }
    @objc func heart(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.item.like = true
        } else {
            self.item.like = false
        }
        self.shared.arrayItems.first(where: {$0.path == item.path})?.like = self.item.like
        self.shared.saveItems()
    }
    @objc func trash(_ sender: UIButton){
        
        shared.arrayItems.remove(at: self.colletionView.index)
        self.colletionView.reloadData()
        shared.saveItems()
        
    }
    private func createCollectionView() {
        colletionView.isPagingEnabled = true
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.performBatchUpdates(nil) { (result) in
            self.colletionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: true)
        }
        colletionView.backgroundColor = .black
        self.view.addSubview(colletionView)
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        colletionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        colletionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        colletionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        colletionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        colletionView.completion = { [weak self] like in
            self?.myButton.isSelected = like
        }
    }
    
    private func saveItem() -> Int {
        var index = 0
        for element in self.shared.arrayItems {
            if element.path == self.item.path {
                self.shared.arrayItems[index] = item
                return index
            }
            index += 1
        }
        self.shared.arrayItems.append(self.item)
        self.shared.saveItems()
        return self.shared.arrayItems.count - 1
    }
    
    
}

