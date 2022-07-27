import UIKit


extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times(closure : ()->Void){
        guard self > 0 else {return}
        for _ in 0..<self {
            closure()
        }
    }
}
3.times {
    print("helloWorld")
}

extension Array where Element:Comparable{
    mutating func remove(item : Element){
        if let index = self.firstIndex(of: item){
            remove(at: index)
        }
    }
}

