//
//  Sturldata.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import CoreTransferable

/// Enum representing transferable data as a string, URL, or raw data, with automatic type inference.
enum Sturldata: Transferable {
    case string(String)
    case url(URL)
    case data(Data)

    init(url: URL) {
        if let imageData = url.dataSchemeImageData {
            self = .data(imageData)
        } else {
            self = .url(url.imageURL)
        }
    }

    init(string: String) {
        if string.hasPrefix("http"), let url = URL(string: string) {
            self = .url(url.imageURL)
        } else {
            self = .string(string)
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation { Sturldata(string: $0) }
        ProxyRepresentation { Sturldata(url: $0) }
        ProxyRepresentation { Sturldata.data($0) }
    }
}


