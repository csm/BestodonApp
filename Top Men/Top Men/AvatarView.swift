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
    @Binding var unreadCount: UInt32
    
    @State var image: UIImage
    
    init(imageUrl: URL, avatarName: String, avatarHandle: String, unreadCount: Binding<UInt32>) {
        self.imageUrl = imageUrl
        self.avatarName = avatarName
        self.avatarHandle = avatarHandle
        self._image = State<UIImage>(initialValue: UIImage(named: "DefaultAvatarImage")!)
        self._unreadCount = unreadCount
    }
    
    var body: some View {
        GeometryReader { proxy in
            let dim = min(proxy.size.width, proxy.size.height)
            let innerDim = dim * 0.85
            let rimDim = (dim - innerDim) / 2
            let badgeDim = dim * 0.25
            let badgePos = sqrt((dim/2)*(dim/2))+badgeDim/2+rimDim/2
            ZStack {
                Circle()
                    .fill(Color(UIColor(named: "AvatarBorderColor")!))
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
                VStack {
                    Spacer().frame(height: badgePos)
                    HStack {
                        Spacer().frame(width: badgePos)
                        unreadBadge.frame(width: badgeDim, height: badgeDim, alignment: .bottom)
                    }
                }
#if DEBUG
                //Text("\(innerDim) \(rimDim) \(badgePos)").colorInvert()
                //Rectangle().stroke(Color.blue)
#endif
            }
        }
    }
    
    private var unreadBadge: some View {
        GeometryReader { proxy in
            HStack {
                if unreadCount == 0 {
                    EmptyView()
                } else {
                    ZStack {
                        Circle().fill(.red)
                        Text(unreadCount < 100 ? "\(unreadCount)" : "99+").foregroundStyle(Color.white)
                            .font(.system(size: fontSize(dim: proxy.size.width * 0.5), weight: .bold))
                            .minimumScaleFactor(0.1)
                    }
                }
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

struct AvatarView_Previews: PreviewProvider {
    @State static var unreadCount: UInt32 = 1
    static var previews: some View {
        AvatarView(imageUrl: URL(string: "https://media.me.dm/accounts/avatars/110/040/810/697/085/526/original/d864c2ba46e020a9.jpeg")!, avatarName: "Casey Marshall", avatarHandle: "@rsdio", unreadCount: $unreadCount)
            .frame(width: 300, height: 500)
    }
}
