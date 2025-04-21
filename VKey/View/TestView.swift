//var myNonActivatingPanel: NSPanel? // Ссылка для хранения панели
//
//    // Метод для создания и показа панели
//    // Его можно вызвать из applicationDidFinishLaunching или по другому событию
//    func createAndShowPanel() {
//        // Предотвращаем повторное создание, если панель уже есть
//        guard myNonActivatingPanel == nil else {
//            myNonActivatingPanel?.orderFront(nil) // Если есть, просто показываем
//            return
//        }
//
//        // 1. Создаем SwiftUI View
//        let swiftUIView = ContentView(appDelegate: self)
//
//        // 2. Создаем NSHostingView для обертки SwiftUI View
//        let hostingView = NSHostingView(rootView: swiftUIView)
//        // Получаем нужный размер из SwiftUI View (если он задан через .frame)
//        let size = hostingView.fittingSize
//
//        // 3. Создаем NSPanel
//        let panel = NSPanel(
//            contentRect: NSRect(origin: .zero, size: size), // Используем размер из hostingView
//            styleMask: [.titled, .closable, .utilityWindow, .nonactivatingPanel], // Наш неактивирующий стиль
//            backing: .buffered,
//            defer: false
//        )
//
//        panel.title = "Моя Панель"
//        panel.level = .floating // Плавающая панель
//        panel.isFloatingPanel = true // Ведет себя как плавающая
//        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // Поведение в Spaces/FullScreen
//        panel.titlebarAppearsTransparent = true // Опционально: прозрачный заголовок
//        panel.standardWindowButton(.closeButton)?.isHidden = true // Опционально: скрыть стандартные кнопки
//
//        // Важно: Предотвращение становления ключевым/главным (хотя .nonactivatingPanel уже это подразумевает)
//        // panel.canBecomeKey = false // Это read-only, определяется стилем
//        // panel.canBecomeMain = false // Это read-only, определяется стилем
//
//        // 4. Устанавливаем NSHostingView как содержимое панели
//        panel.contentView = hostingView
//
//        // 5. Сохраняем ссылку и показываем панель
//        self.myNonActivatingPanel = panel
//        panel.center() // Центрируем на экране
//        panel.orderFront(nil) // Показываем окно
//    }
//
//    // Пример: Создаем панель сразу при запуске приложения
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        print("App finished launching, creating panel...")
//        // Даем небольшую задержку, чтобы главный цикл событий запустился
//         DispatchQueue.main.async {
//             self.createAndShowPanel()
//         }
//    }
//
//func closePanel() {
//    myNonActivatingPanel?.close()
//    myNonActivatingPanel = nil // Очищаем ссылку
//}


