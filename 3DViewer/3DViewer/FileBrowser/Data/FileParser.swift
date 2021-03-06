//
//  FileParser.swift
//  3DViewer
//
//  Created by Eugene Bokhan on 9/14/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Foundation

open class FileParser {
    
    // MARK: - Properties
    
    static open let sharedInstance = FileParser()
    
    var _excludesFileExtensions = [String]()
    
    /// Mapped for case insensitivity
    var excludesFileExtensions: [String]? {
        get {
            return _excludesFileExtensions.map({$0.lowercased()})
        }
        set {
            if let newValue = newValue {
                _excludesFileExtensions = newValue
            }
        }
    }
    
    var excludesFilepaths: [URL]?
    
    let fileManager = FileManager.default
    
    // MARK: - Methods
    
    open func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    func filesForDirectory(_ directoryPath: URL) -> [FBFile]  {
        var files = [FBFile]()
        var filePaths = [URL]()
        // Get contents
        do  {
            filePaths = try self.fileManager.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        } catch {
            return files
        }
        // Parse
        for filePath in filePaths {
            let file = FBFile(filePath: filePath)
            if let excludesFileExtensions = excludesFileExtensions, let fileExtensions = file.fileExtension , excludesFileExtensions.contains(fileExtensions) {
                continue
            }
            if let excludesFilepaths = excludesFilepaths , excludesFilepaths.contains(file.filePath) {
                continue
            }
            if file.displayName.isEmpty == false {
                files.append(file)
            }
        }
        // Sort
        files = files.sorted(){$0.displayName < $1.displayName}
        return files
    }
    
}

