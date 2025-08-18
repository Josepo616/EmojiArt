//
//  UrlExtension.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/18/25.
//

import CoreTransferable

/// URL extension that extracts a direct image URL from query parameters
/// or decodes inline base64 image data from a data URL scheme.
extension URL {
    var imageURL: URL {
        if let queryItems = URLComponents(
            url: self,
            resolvingAgainstBaseURL: true
        )?.queryItems {
            for queryItem in queryItems {
                if let value = queryItem.value, value.hasPrefix("http"),
                    let imgurl = URL(string: value)
                {
                    return imgurl
                }
            }
        }
        return self
    }

    var dataSchemeImageData: Data? {
        let urlString = absoluteString
        if urlString.hasPrefix("data:image") {
            if let comma = urlString.firstIndex(of: ","),
                comma < urlString.endIndex
            {
                let meta = urlString[..<comma]
                if meta.hasSuffix("base64") {
                    let data = String(urlString.suffix(after: comma))
                    if let imageData = Data(base64Encoded: data) {
                        return imageData
                    }
                }
            }
        }
        return nil
    }
}
