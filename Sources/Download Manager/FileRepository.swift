//
//  File 2.swift
//  
//
//  Created by Alessandro Loi on 13/05/22.
//

import Foundation

final class FileRepository {
    
    func get(_ file: File) -> Result<File, FileHandlerError> {
        guard
            let name = file.name,
            let enumerator = FileManager.default.enumerator(at: FileManager.default.urls(for: file.directory, in: .userDomainMask)[0],
                                                            includingPropertiesForKeys: [.isRegularFileKey],
                                                            options: [.skipsHiddenFiles, .skipsPackageDescendants])
        else {
            return .failure(.invalidURL)
        }
        
        for case let fileURL as URL in enumerator {
            do {
                guard
                    try fileURL.resourceValues(forKeys:[.isRegularFileKey]).isRegularFile == true
                else {
                    return .failure(.invalidURL)
                }
                
                if fileURL.absoluteString.contains(name) {
                    return .success(File(url: fileURL,
                                         named: name,
                                         directory: file.directory,
                                         downloadConfiguration: file.downloadConfiguration))
                }
                
            } catch {
                print(error, fileURL)
            }
        }
        
        return .failure(.invalidURL)
    }
}
