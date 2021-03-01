//
//  PhotoService.swift
//  PhotoTaker
//
//  Created by Lucas Bighi on 01/03/21.
//

import Foundation
import UIKit
import Photos

struct PhotoService {
    private let assetCollection: PHAssetCollection
    private let photosAsset: PHFetchResult<PHAsset>
    private let assetThumbnailSize: CGSize
    
    init(assetThumbnailSize: CGSize) {
        self.assetThumbnailSize = assetThumbnailSize
        
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: PHFetchOptions())

        guard let firstObject = collection.firstObject else {
            fatalError("Unable to get assets")
        }
        
        assetCollection = firstObject
        
        guard let results = (PHAsset.fetchAssets(in: assetCollection, options: nil) as AnyObject) as? PHFetchResult<PHAsset> else {
            fatalError("Unable to get assets")
        }
        
        photosAsset = results
    }
    
    func numberOfAssets() -> Int {
        return photosAsset.count
    }
    
    func asset(atPosition position: Int) -> PHAsset {
        return photosAsset[position]
    }
    
    func requestImage(forAssetAtPosition position: Int, completionHandler: @escaping(UIImage?) -> Void) {
        PHImageManager.default().requestImage(for: asset(atPosition: position),
                                              targetSize: assetThumbnailSize,
                                              contentMode: .aspectFill,
                                              options: nil,
                                              resultHandler: { result, _ in
            completionHandler(result)
        })
    }
}
