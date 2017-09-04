//
//  SendDataDelegate.swift
//  Pretium
//
//  Created by Staham Nguyen on 16/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

protocol SendAndReceiveDataDelegate {
    func handleCategory(withName name: String)
    func handle(kit: Kit)
}
