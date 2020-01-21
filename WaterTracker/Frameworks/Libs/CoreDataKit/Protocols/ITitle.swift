//
//  ITitle.swift
//  CoreDataKit
//
//  Created by nik on 28.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation

@objc public protocol ITitle: AnyObject {
    
    func  getId() -> NSObject
    func  getTitle() -> String
}


