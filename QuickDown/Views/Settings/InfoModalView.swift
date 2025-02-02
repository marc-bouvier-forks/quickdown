import SwiftUI
import AppKit
import LaunchAtLogin

struct InfoModalView: View {
    @Binding var showModal: Bool
    @State var disableCommandQuit: Bool = UserDefaults.standard.bool(forKey: "DisableCommandQuit")
    @State var markdownTemplate: String = UserDefaults.standard.string(forKey: "MarkdownTemplate") ?? ""
    @State var markdownTemplateSaveMessage: String = ""
    
    var body: some View {
        ZStack {
            TabView {
                List {
                    HStack {
                        Text("Global Hotkey")
                        Text("⌘-⌥-D")
                            .bold()
                    }
                    
                    HStack {
                        Text("Save Note")
                        Text("⌘-S")
                            .bold()
                    }
                    
                    HStack {
                        Text("Open Note")
                        Text("⌘-O")
                            .bold()
                    }
                    
                    HStack {
                        Text("Dismiss Popover")
                        Text("Esc")
                            .bold()
                    }
                    
                }.tabItem { Text("Hotkeys") }
                List {
                    TextEditor(text: $markdownTemplate)
                        .foregroundColor(.primary)
                        .font(.system(.body, design: .monospaced))
                        .frame(width: .infinity, height: 100)
                        .onChange(of: markdownTemplate) { newValue in
                            self.saveMarkdownTemplate()
                        }
                    Text("Available Directives: %CURSOR% %DATETIME% %DATE% %TIME% %CLIPBOARD% %ID% %UUID% %ZKID%")
                        .font(.footnote)

                    HStack {
                        Text(markdownTemplateSaveMessage)
                            .font(.footnote)
                            .foregroundColor(.green)

                    }
                    
                }.tabItem { Text("Template") }
                
                List {
                    Text("If you like having QuickDown around, toggle the following switch to launch after logging in:")
                    LaunchAtLogin.Toggle()
                }.tabItem { Text("Login") }
                
                List {
                    Text("Avoid accidental ⌘-Q quitting while QuickDown still has an invisble focus (eA general issue I've found with menu bar apps.)")
                    
                    HStack {
                        Button(action: {
                            self.disableCommandQuit.toggle()
                            UserDefaults.standard.set(self.disableCommandQuit, forKey: "DisableCommandQuit")
                        }, label: {
                            Text("Override ⌘-Q")
                        })
                        
                        if(disableCommandQuit) {
                            Text("Disabled")
                                .foregroundColor(.blue)
                            
                        } else {
                            Text("Enabled")
                                .foregroundColor(.green)
                            
                        }
                    }
                }.tabItem { Text("Quitting") }
                
                List {
                    Text("Version: 2.4")
                    Text("Contact: alexis.rondeau@gmail.com")
                    Text("Web: https://akaalias.github.io/getquickdown")
                    Text("Code: https://github.com/akaalias/quickdown")
                }.tabItem { Text("About") }
            }
            
            Button(action: {
                self.showModal.toggle()
            }, label: {
                Text("Close")
            })
                .buttonStyle(.bordered)
                .offset(x: 0, y:103)
        }
        .padding(20)
        .onExitCommand(perform: {
            self.showModal.toggle()
        })
        .frame(width: 400, height: 280, alignment: .top)
    }
    
    func saveMarkdownTemplate() {
        UserDefaults.standard.set(self.markdownTemplate, forKey: "MarkdownTemplate")
        self.markdownTemplateSaveMessage = "Template saved"
    }
}
