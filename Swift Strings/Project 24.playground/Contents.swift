import UIKit

let name = "Andrew"
for letter in name {
    print(letter)
}

let letter = name[ name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i:Int)->String {
        return String( self[ index(startIndex, offsetBy: i) ] )
    }
    func deletePrefix(_ prefix : String)->String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func deleteSuffix(_ suffix : String)->String{
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    var capitalizedFirst : String {
        guard let firseLetter = self.first else {return ""}
        return firseLetter.uppercased() + self.dropFirst(1)
    }
    func containsAny(of array : [String])->Bool{
        for item in array {
            if self.contains(item){
                return true
            }
        }
        return false
    }
    func withPrefix(_ prefix : String)->String{
        if self.hasPrefix(prefix){
            return self
        }
        return prefix + self
    }
    func isNumeric()->Bool{
        if let _ = Int(self){
            return true
        }
        else if let _ = Double(self){
            return true
        }
        return false
    }
    var lines : [String]{
        return self.components(separatedBy: "\n")
    }
}

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

input.containsAny(of: languages)
languages.contains(where: input.contains)

let string = "This is a test string"
let attributes : [NSAttributedString.Key:Any] = [
    .foregroundColor : UIColor.white ,
    .backgroundColor : UIColor.red ,
    .font: UIFont.boldSystemFont(ofSize: 36)
]
let attributedString = NSAttributedString(string: string, attributes: attributes)


let mutableAttributedString = NSMutableAttributedString(string: string)
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


