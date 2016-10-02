import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var menu: NSMenu = NSMenu()
    var menuItem : NSMenuItem = NSMenuItem()
    var refreshItem : NSMenuItem = NSMenuItem()
    
    override init(){
        super.init()
        statusItem.title = "loading..."
        statusItem.menu = menu
        menuItem.title = "Quit"
        menuItem.target = self
        menuItem.action = #selector(quitClicked(sender:))
        refreshItem.title = "refresh"
        refreshItem.target = self
        refreshItem.action = #selector(updateInfo(sender:))
        menu.addItem(refreshItem)
        menu.addItem(menuItem)
    }
    
    func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    func updateInfo(sender: NSMenuItem?) {
        NSLog("refreshing...")
        let url = URL(string: "https://hi.singtel.com/welcome.do")
        do {
            let myHTMLString = try String(contentsOf: url!)
            do {
                let regex = try NSRegularExpression(pattern: "\\n\\s*([\\d\\.]*)\\s*[MG]B\\s*\\n")
                let range = NSMakeRange(0, myHTMLString.characters.count)
                let nsString = myHTMLString as NSString
                let matches = regex.matches(in: myHTMLString, range: range)
                // matches.map({NSLog(nsString.substring(with: $0.rangeAt(1)))})
                let result = matches.map({ Int(nsString.substring(with: $0.rangeAt(1)).replacingOccurrences(of: ".", with: "")) ?? 0}).reduce(0, {$0 + $1})
                statusItem.title = String(String(result) + " MB")
                NSLog(String(result), " MB")
            }catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }catch let error as NSError {
            NSLog(error.localizedDescription)
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        updateInfo(sender:nil)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateInfo), userInfo: nil, repeats: true)
    }
    
}
