//
//  MediaSelecting.swift
//  CollectionViewTest2
//
//  Created by GabrielChen on 2020/3/16.
//  Copyright © 2020 Ray. All rights reserved.
//

import Foundation

enum MediaSelectingType: Int{
    case image = 1
    case video = 2
}

struct MediaSelecting {
    var filename: String = ""
    var mediatype: MediaSelectingType = .image
    var filepath: String = ""
}
