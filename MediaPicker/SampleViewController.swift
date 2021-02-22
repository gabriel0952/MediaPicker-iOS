//
//  InitViewController.swift
//  CollectionViewTest2
//
//  Created by GabrielChen on 2020/3/13.
//  Copyright © 2020 Ray. All rights reserved.
//

import UIKit

// This ViewController is a sample to show picker and viewer how to use
class SampleViewController: UIViewController {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var addButtonView: UIButton!
    @IBOutlet weak var camaraButtonView: UIButton!
    @IBOutlet weak var photoButtonView: UIButton!
    @IBOutlet weak var selectNum: UILabel!
    
    var filePathArray = Array<String>()
    var fileTypeArray = Array<MediaSelectingType>()
    var senderNameArray = Array<String>()
    var sendTime = Array<Date>()
    private var index = 0
    
    var photoViewController: MediaSelectViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoPicker") as! MediaSelectViewController
        
        camaraButtonView.isHidden = true
        photoButtonView.isHidden = true
        
        photoViewController.delegate = self
        
        addChild(photoViewController)
        photoView.addSubview(photoViewController.view)
        photoViewController.didMove(toParent: self)
        UIUtil.constrainViewEqual(holderView: photoView, view: photoViewController.view)
        
        photoView.isHidden = true
    }
    
    // MARK: Picker setup
    @IBAction func addButtonAction(_ sender: Any) {
        if camaraButtonView.isHidden {
            addButtonView.setImage(UIImage(named: "sun.min"), for: .normal)
            camaraButtonView.isHidden = false
            photoButtonView.isHidden = false
        } else {
            addButtonView.setImage(UIImage(named: "icon_forward_1"), for: .normal)
            camaraButtonView.isHidden = true
            photoButtonView.isHidden = true
            clean()
        }
    }
    
    @IBAction func showPhoto(_ sender: Any) {
        if photoView.isHidden {
            photoView.isHidden = false
            photoViewController.photoCollectionViewController.reloadData()
        } else {
            photoView.isHidden = true
        }
    }
    
    @IBAction func sendPhoto(_ sender: Any) {
        if photoViewController.selectMediaFileArray.isEmpty {
            print("Array is empty")
        } else {
            print(photoViewController.selectMediaFileArray)
            clean()
        }
    }
    
    func clean(){
        addButtonView.setImage(UIImage(named: "icon_forward_1"), for: .normal)
        camaraButtonView.isHidden = true
        photoButtonView.isHidden = true
        
        photoView.isHidden = true
        photoViewController.seleceMediaArray.removeAll()
        photoViewController.seleceMediaArray = Array(repeating: -1, count: photoViewController.assetsFetchResults?.count ?? 0)
        photoViewController.selectMediaFileArray.removeAll()
        photoViewController.selectedNumPhoto = 0
        selectNum.text = ""
    }
}

extension SampleViewController: mediaSelectAction {
    func selectedAction(addAction: Bool) {
        selectNum.text = "\(photoViewController.selectMediaFileArray.count) / 50"
    }
}
