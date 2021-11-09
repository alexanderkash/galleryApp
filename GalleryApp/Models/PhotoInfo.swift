//
//  PhotoInfo.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import Foundation

struct PhotoInfo: Decodable {
    
    let photoUrl: String
    let userName: String
    let userUrl: String
    
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case photoUrl = "photo_url"
        case userName = "user_name"
        case userUrl = "user_url"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        photoUrl = try container.decode(String.self, forKey: CodingKeys.photoUrl)
        userName = try container.decode(String.self, forKey: CodingKeys.userName)
        userUrl = try container.decode(String.self, forKey: CodingKeys.userUrl)
        
        url = container.codingPath.first!.stringValue
    }
}
