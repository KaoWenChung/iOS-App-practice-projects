import UIKit

extension UIImage {
    func scale(newWidth: CGFloat) -> UIImage {
        
        // Make sure the width is different from now
        if self.size.width == newWidth {
            return self
        }
        
        // cauculate the scale factor
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x:0, y:0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
