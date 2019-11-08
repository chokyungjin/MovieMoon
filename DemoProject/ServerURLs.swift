//
//  ServerURLs.swift
//  boxoffice
//
//  Created by Cho on 16/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

enum ServerURLs: String {
    case base = "http://connect-boxoffice.run.goorm.io"
    case movieList = "/movies?order_type="
    case movieDetail = "/movie?id="
    case movieComments = "/comments?movie_id="
}
