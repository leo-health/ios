//
//  LEOCachedDataStore+DiskImage.swift
//  Leo
//
//  Created by Adam Fanslau on 8/9/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

extension LEOCachedDataStore {

    private func getDocumentsURL() -> NSURL {

        return NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory,
                              inDomains: .UserDomainMask)[0]
    }

    private func pathInDocumentsDirectory(filename: String) -> NSURL {

        return getDocumentsURL()
            .URLByAppendingPathComponent(filename)
    }

    public func saveImageToDisk(image: UIImage, filename: String ) -> Bool {

        let manager = NSFileManager.defaultManager()
        let url = pathInDocumentsDirectory(filename)

        do {
            let directory = url.URLByDeletingLastPathComponent!
            try manager.createDirectoryAtURL(directory,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
        } catch {
            return false
        }

        return manager.createFileAtPath(url.path!,
                                        contents: UIImagePNGRepresentation(image),
                                        attributes: nil)
    }

    public func loadImageFromDisk(filename: String) -> UIImage? {

        // http://stackoverflow.com/questions/10685276/iphone-ios-saving-data-obtained-from-uiimagejpegrepresentation-fails-second-ti
        guard let data = NSData(contentsOfFile: pathInDocumentsDirectory(filename).path!) else {
            return nil
        }
        return UIImage(data: data)
    }
}
