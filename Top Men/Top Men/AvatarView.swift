//
//  AvatarView.swift
//  Top Men
//
//  Created by Casey Marshall on 3/3/24.
//

import SwiftUI
import CrookedText

struct AvatarView: View {
    public let imageUrl: URL
    public let avatarName: String
    public let avatarHandle: String
    
    @State var image: UIImage
    
    init(imageUrl: URL, avatarName: String, avatarHandle: String) {
        self.imageUrl = imageUrl
        self.avatarName = avatarName
        self.avatarHandle = avatarHandle
        self._image = State<UIImage>(initialValue: UIImage(named: "DefaultAvatarImage")!)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let dim = min(proxy.size.width, proxy.size.height)
            let innerDim = dim * 0.85
            let rimDim = (dim - innerDim) / 2
            ZStack {
                Circle()
                    .fill(Color.secondary)
                    .frame(width: dim, height: dim)
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: innerDim, height: innerDim, alignment: .center)
                        .clipShape(Circle())
                } placeholder: {
                    Image(uiImage: UIImage(named: "DefaultAvatarImage")!)
                        .scaledToFill()
                        .frame(width: innerDim, height: innerDim, alignment: .center)
                        .clipShape(Circle())
                }
                CrookedText(text: avatarName, radius: innerDim/2, alignment: .outside)
                    .font(.system(size: fontSize(dim: rimDim)))
                CrookedText(text: avatarHandle, radius: innerDim/2, alignment: .outside, direction: .counterclockwise)
                    .advance(radians: .pi)
                    .font(.system(size: fontSize(dim: rimDim)))
                //Text("\(innerDim) \(rimDim) \(fontSize(dim: rimDim))")
            }
        }
    }
    
    private func fontSize(dim: CGFloat) -> CGFloat {
        var fontSize: CGFloat = 1
        repeat {
            let font = UIFont.systemFont(ofSize: fontSize)
            let attrib = [NSAttributedString.Key.font: font]
            let text = "M"
            let size = text.size(withAttributes: attrib)
            NSLog("TOP_MEN: fontSize for dim \(dim) fontSize: \(fontSize) height: \(size.height)")
            if size.height > dim {
                return fontSize - 0.25
            }
            fontSize += 0.25
        } while true
    }
}

#Preview {
    AvatarView(imageUrl: URL(string: "https://media.me.dm/accounts/avatars/110/040/810/697/085/526/original/d864c2ba46e020a9.jpeg")!, avatarName: "Casey Marshall", avatarHandle: "@rsdio")
        .frame(width: 300, height: 500)
}
