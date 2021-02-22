//
//  ViewController.swift
//  CollectionViewTest2
//
//  Created by GabrielChen on 2020/3/13.
//  Copyright © 2020 Ray. All rights reserved.
//

import UIKit
import Photos

protocol mediaSelectAction {
    func selectedAction(addAction: Bool)
}

class MediaSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellSizeWidth = (UIScreen.main.bounds.size.width - 2) / 3
    let cellSizeHeight = (UIScreen.main.bounds.size.height - 2) / 3
    var seleceMediaArray: Array<Int> = []
    var selectMediaFileArray: Array<MediaSelecting> = []
    public var selectedNumPhoto = 0
    
    var assetsFetchResults: PHFetchResult<PHAsset>?
    var assetGridThumbnailSize: CGSize!
    var imageManager: PHCachingImageManager!
    var delegate: mediaSelectAction?
    
    @IBOutlet weak var photoCollectionViewController: UICollectionView!
    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        let scale = UIScreen.main.scale
        assetGridThumbnailSize = CGSize(width: cellSizeWidth * scale ,height: cellSizeHeight * scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoCollectionViewFlowLayout.minimumLineSpacing = 1
        photoCollectionViewFlowLayout.minimumInteritemSpacing = 1
        photoCollectionViewFlowLayout.itemSize = CGSize(width: cellSizeWidth, height: cellSizeWidth)
        photoCollectionViewFlowLayout.scrollDirection = .vertical
        photoCollectionViewFlowLayout.prepare()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                return
            }
            
            // get all photo/video
            let allMediaOptions = PHFetchOptions()
            // order by create time
            allMediaOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.assetsFetchResults = PHAsset.fetchAssets(with: allMediaOptions)
            self.seleceMediaArray = Array(repeating: -1, count: self.assetsFetchResults?.count ?? 0)
            
            // initial and reset cache
            self.imageManager = PHCachingImageManager()
            self.resetCachedAssets()
             
            // collection view reload
            DispatchQueue.main.async{
                self.photoCollectionViewController?.reloadData()
            }
        }
    }
    
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }

    // MARK: Functions of CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! MediaCollectionViewCell
        cell.videoIconView.isHidden = true
        cell.videoDurationTextView.isHidden = true
        
        // Set up thumbnail
        if let asset = self.assetsFetchResults?[indexPath.row] {
            self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (img, nfo) in
                cell.photoImageView.image = img
            }
            
            // Set the video icon and duration for video
            if asset.mediaType.rawValue == 2 {
                cell.videoIconView.isHidden = false
                cell.videoDurationTextView.isHidden = false
                
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .full

                let formattedString = formatter.string(from: TimeInterval(asset.duration))!
                let durationHr = Int(asset.duration / 3600)
                let durationMin = Int(asset.duration.truncatingRemainder(dividingBy: 3600) / 60)
                let durationSec = Int(asset.duration.truncatingRemainder(dividingBy: 3600))

                if durationHr >= 1 {
                    cell.videoDurationTextView.text = getStringFormat(durationHr) + ":" + getStringFormat(durationMin) + ":" + getStringFormat(durationSec)
                } else {
                    cell.videoDurationTextView.text = getStringFormat(durationMin) + ":" + getStringFormat(durationSec)
                }
            }
        }
        
        // Set up number text view
        cell.selectedNumTextView.clipsToBounds = true
        cell.selectedNumTextView.layer.borderWidth = 1.5
        cell.selectedNumTextView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.selectedNumTextView.layer.cornerRadius = cellSizeWidth / 10;
        
        if seleceMediaArray[indexPath.row] > 0 {
            cell.selectedNumTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.selectedNumTextView.backgroundColor = #colorLiteral(red: 0, green: 0.87109375, blue: 0, alpha: 1)
            cell.selectedNumTextView.alpha = 1
            cell.selectedNumTextView.text = "\(seleceMediaArray[indexPath.row])"
        } else {
            cell.selectedNumTextView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.selectedNumTextView.alpha = 0.5
            cell.selectedNumTextView.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell{
            // Set up number and array while the media is selected
            if seleceMediaArray[indexPath.row] > 0 {
                
                for index in 0...seleceMediaArray.count-1 {
                    if seleceMediaArray[index] > seleceMediaArray[indexPath.row] {
                        seleceMediaArray[index] -= 1
                    }
                }
                
                selectMediaFileArray.remove(at: seleceMediaArray[indexPath.row]-1)
                selectedNumPhoto -= 1
                seleceMediaArray[indexPath.row] = -1
                
                delegate?.selectedAction(addAction: false)
                
                cell.selectedNumTextView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.selectedNumTextView.alpha = 0.5
                cell.selectedNumTextView.text = ""
                
                collectionView.reloadData()
            } else {
                if selectedNumPhoto < 50 {
                    selectedNumPhoto += 1
                    seleceMediaArray[indexPath.row] = selectedNumPhoto
                    
                    FileHandler(indexpath: indexPath)
                    
                    cell.selectedNumTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.selectedNumTextView.backgroundColor = #colorLiteral(red: 0, green: 0.87109375, blue: 0, alpha: 1)
                    cell.selectedNumTextView.alpha = 1
                    cell.selectedNumTextView.text = "\(seleceMediaArray[indexPath.row])"
                }
            }
        }
    }
    
    // MARK: Other functions
    func getStringFormat(_ time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    func FileHandler(indexpath: IndexPath) {
        assetsFetchResults?[indexpath.row].requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, requestStatusInfo) in

            if contentEditingInput != nil && contentEditingInput!.mediaType.rawValue == 1 {
                let fileInfo = MediaSelecting (
                    filename: contentEditingInput?.fullSizeImageURL?.lastPathComponent ?? "",
                    mediatype: MediaSelectingType(rawValue: (contentEditingInput?.mediaType.rawValue)!)!,
                    filepath: (contentEditingInput?.fullSizeImageURL!.path)!
                )
                self.selectMediaFileArray.append(fileInfo)
            } else {
                let assetUrl = contentEditingInput?.audiovisualAsset as! AVURLAsset
                let fileInfo = MediaSelecting(
                    filename: assetUrl.url.lastPathComponent,
                    mediatype: MediaSelectingType(rawValue: (contentEditingInput?.mediaType.rawValue)!)!,
                    filepath: assetUrl.url.path
                )
                self.selectMediaFileArray.append(fileInfo)
            }
            self.delegate?.selectedAction(addAction: true)
            
        })
    }
}

