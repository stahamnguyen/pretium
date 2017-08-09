import UIKit

extension AppDelegate {
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone6 () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    class func isIPhone6Plus () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
    
    class func fontSize(forIphone5 iPhone5Font : CGFloat, forIphone6 iPhone6Font : CGFloat, forIphone6Plus iPhone6PlusFont : CGFloat) -> CGFloat {
        if (isIPhone5()) {
            return iPhone5Font
        } else if (isIPhone6()) {
            return iPhone6Font
        } else {
            return iPhone6PlusFont
        }
    }
}
