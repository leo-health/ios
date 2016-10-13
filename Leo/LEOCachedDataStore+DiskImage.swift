//
//  LEOCachedDataStore+DiskImage.swift
//  Leo
//
//  Created by Adam Fanslau on 8/9/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

extension LEOCachedDataStore {

    fileprivate func getDocumentsURL() -> URL {

        return FileManager.default
            .urls(for: .documentDirectory,
                              in: .userDomainMask)[0]
    }

    fileprivate func pathInDocumentsDirectory(_ filename: String) -> URL {

        return getDocumentsURL()
            .appendingPathComponent(filename)
    }

    public func saveImageToDisk(_ image: UIImage, filename: String ) -> Bool {

        let manager = FileManager.default
        let url = pathInDocumentsDirectory(filename)

        do {
            let directory = url.deletingLastPathComponent()
            try manager.createDirectory(at: directory,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
        } catch {
            return false
        }

        return manager.createFile(atPath: url.path,
                                        contents: UIImagePNGRepresentation(image),
                                        attributes: nil)
    }

    public func loadImageFromDisk(_ filename: String) -> UIImage? {

        // http://stackoverflow.com/questions/10685276/iphone-ios-saving-data-obtained-from-uiimagejpegrepresentation-fails-second-ti
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: pathInDocumentsDirectory(filename).path)) else {
            return nil
        }
        return UIImage(data: data)
    }
}
