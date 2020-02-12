//
//  PostImageModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/10.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
// MARK: - PostImageModel
// 여기서 location이 이미지 경로
//{
//    "fieldname": "image",
//    "originalname": "IMG_9090.JPG",
//    "encoding": "7bit",
//    "mimetype": "image/jpeg",
//    "size": 301569,
//    "bucket": "moviemoon1",
//    "key": "original/1581314941317IMG_9090.JPG",
//    "acl": "private",
//    "contentType": "application/octet-stream",
//    "contentDisposition": null,
//    "storageClass": "STANDARD",
//    "serverSideEncryption": null,
//    "metadata": null,
//    "location": "https://moviemoon1.s3.ap-northeast-2.amazonaws.com/original/1581314941317IMG_9090.JPG",
//    "etag": "\"1efb69b6b6a80c57c8974f1f91157ae3\""
//}
//{
//    acl = private;
//    bucket = moviemoon1;
//    contentDisposition = "<null>";
//    contentType = "application/octet-stream";
//    encoding = 7bit;
//    etag = "\"880fee12b750d51bbd28f2624750f400\"";
//    fieldname = image;
//    key = "original/1581322710418file.jpg";
//    location = "https://moviemoon1.s3.ap-northeast-2.amazonaws.com/original/1581322710418file.jpg";
//    metadata = "<null>";
//    mimetype = "image/jpeg";
//    originalname = "file.jpg";
//    serverSideEncryption = "<null>";
//    size = 450321;
//    storageClass = STANDARD;
//}

// 성공했을 때 response body


struct PostImageModel: Codable {
    let fieldname: String
    let originalname: String
    let encoding: String
    let mimetype: String
    let size: Int
    let bucket: String
    let key: String
    let acl: String
    let contentType: String
    let contentDisposition: String? = nil
    let storageClass: String
    let serverSideEncryption: String? = nil
    let metadata: String? = nil
    let location: String
    let etag : String

}

