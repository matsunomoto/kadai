//
//  MemberData.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/08.
//  Copyright © 2018年 User4. All rights reserved.
//

import Foundation


class MemberData : NSObject, NSCoding {
    var lastname : String?
    var firstname : String?
    var password : String?
    var mailaddress : String?
    var born : Date?
    
    init(
        lastname: String?,
        firstname: String?,
        password: String?,
        mailaddress: String?,
        born: Date?
        )
    {
        self.lastname = lastname
        self.firstname = firstname
        self.password = password
        self.mailaddress = mailaddress
        self.born = born
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lastname, forKey:"lastname")
        aCoder.encode(firstname, forKey:"firstname")
        aCoder.encode(password, forKey:"password")
        aCoder.encode(mailaddress, forKey:"mailaddress")
        aCoder.encode(born, forKey:"born")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lastname = aDecoder.decodeObject(forKey: "lastname") as? String
        self.firstname = aDecoder.decodeObject(forKey: "firstname") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.mailaddress = aDecoder.decodeObject(forKey: "mailaddress") as? String
        self.born = aDecoder.decodeObject(forKey: "born") as? Date
    }
}
