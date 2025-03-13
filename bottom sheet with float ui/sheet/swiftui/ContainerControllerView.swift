//import SwiftUI
//import Combine
//import ObjectiveC
//
//// MARK: - Объект-хранилище для ContainerController
//final class ContainerHolder: ObservableObject {
//    @Published var container: ContainerController?
//    @Published var containerPosition = ContainerPosition(top: 80, middle: nil, bottom: 80)
//    
//    func moveToTop(animation: Bool = true, velocity: CGFloat = 0.0, completion: (() -> Void)? = nil) {
//        container?.move(type: .top, animation: animation, velocity: velocity, from: .custom, completion: completion)
//    }
//    func moveToBottom(animation: Bool = true, velocity: CGFloat = 0.0, completion: (() -> Void)? = nil) {
//        container?.move(type: .bottom, animation: animation, velocity: velocity, from: .custom, completion: completion)
//    }
//    func moveTo(position: CGFloat, animation: Bool = true, velocity: CGFloat = 0.0, completion: (() -> Void)? = nil) {
//        container?.move(position: position, animation: animation, type: .custom, velocity: velocity, from: .custom, completion: completion)
//    }
//}
//
//// MARK: - Пример SwiftUI-вида, использующего контейнер через ContainerHolder
//struct ContainerControllerView: View {
//    // Вместо прямого хранения ContainerController, теперь наблюдаем за ContainerHolder
//    @StateObject var containerHolder = ContainerHolder()
//    
//    @State private var items: [String] = (1...5).map { "Элемент \($0)" }
//    @StateObject var mapLibreViewModel: MapLibreViewModel = MapLibreViewModel()
//    
//    var body: some View {
//        ZStack {
//            Color.red.opacity(0.2)
//                .ignoresSafeArea()
//            
//            CustomButton(title: "Open") {
//                // Действие для кнопки, если необходимо
//            }
//            
//            // Передаём containerHolder, если требуется дальнейшая реакция на изменения container
//            ContainerControllerRepresentable(
//                sheetContent: {
//                    VStack {
//                        HStack {
//                            Button("Add") {
//                                items.append("Элемент \(items.count + 1)")
//                            }
//                            Button("Delete") {
//                                if !items.isEmpty {
//                                    items.removeLast()
//                                }
//                            }
//                        }
//                        VStack(spacing: 20) {
//                            ForEach(items, id: \.self) { item in
//                                Text(item)
//                                    .padding()
//                                    .background(Color.yellow.opacity(0.3))
//                                    .cornerRadius(8)
//                            }
//                        }
//                        .padding()
//                        Spacer().frame(height: 100)
//                    }
//                },
//                content: {
//                    VStack{
//                        Button(action: {
//                            containerHolder.containerPosition = ContainerPosition(top: 80, middle: nil, bottom: 80)
//                            containerHolder.moveToBottom()
//                        }, label: {
//                            Text("sdad")
//                        })
//                        Button(action: {
//                            containerHolder.containerPosition = ContainerPosition(top: 160, middle: nil, bottom: 160)
//                            containerHolder.moveToBottom()
//                        }, label: {
//                            Text("sdad")
//                        })
//                        Button(action: {
//                            containerHolder.moveToTop()
//                        }, label: {
//                            Text("sdad")
//                        })
//                    }
//                }, floatContent: {
//                    Button(action:{
//                        print("aaaaaaaaaa")
//                    }, label: {
//                        Text("tap")
//                            .foregroundColor(.red)
//                            .padding()
//                            
//                            .background(.green)
//                    })
//                    
//                },
//                containerHolder: containerHolder // передаём обёртку
//            )
//        }
//    }
//}
//
//struct ContainerControllerRepresentable<SheetContent: View, Content: View, FloatContent: View>: UIViewControllerRepresentable {
//    let sheetContent: SheetContent
//    let content: Content
//    let floatContent: FloatContent
//    var containerHolder: ContainerHolder
//    
//    init(
//        @ViewBuilder sheetContent: () -> SheetContent,
//        @ViewBuilder content: () -> Content,
//        @ViewBuilder floatContent: () -> FloatContent,
//        containerHolder: ContainerHolder
//    ) {
//        self.sheetContent = sheetContent()
//        self.content = content()
//        self.floatContent = floatContent()
//        self.containerHolder = containerHolder
//    }
//    
//    func makeUIViewController(context: Context) -> ContainerDemoViewController {
//        ContainerDemoViewController(sheetContent: sheetContent, content: content, floatContent: floatContent, containerHolder: containerHolder)
//    }
//    
//    func updateUIViewController(_ uiViewController: ContainerDemoViewController, context: Context) {
//        uiViewController.updateContent(mainContent: sheetContent, sheetContent: content, floatContent: floatContent)
//    }
//}
//
//
//class ContainerDemoViewController: UIViewController, ContainerControllerDelegate {
//    
//    var containerHolder: ContainerHolder
//    var container: ContainerController! {
//        didSet {
//            containerHolder.container = container
//        }
//    }
//    
//    let hostingFloat = floatViewController()
//    
//    private lazy var floatingButton: UIButton = {
//        let button = UIButton()
//        button.setImage(
//            UIImage(systemName: "list.dash"), for: .normal
//        )
//        button.addTarget(
//            self,
//            action: #selector(move),
//            for: .touchUpInside
//        )
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .systemBackground.withAlphaComponent(0.95)
//        button.layer.cornerRadius = 20.0
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.5
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowRadius = 4.0
//        button.layer.shouldRasterize = true
//        button.layer.rasterizationScale = UIScreen.main.scale
//        return button
//    }()
//    
//
//    
//    var backgroundHosting: UIViewController?
//    var mainHosting: UIHostingController<AnyView>?
//    var sheetHosting: UIHostingController<AnyView>?
//    var floatHosting: UIHostingController<AnyView>? // Для плавающего контента
//    
//    var containerScrollView: UIScrollView?
//    var containerFooterView: UIView?
//    
//    let sheetContent: AnyView
//    let content: AnyView
//    let floatContent: AnyView
//    
//    private lazy var fView: UIView = {
//        let button = UIView()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .systemBackground.withAlphaComponent(0.95)
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.5
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowRadius = 4.0
//        button.layer.shouldRasterize = true
//        button.layer.rasterizationScale = UIScreen.main.scale
//        
//        return button
//    }()
//    
//    private var cancellables = Set<AnyCancellable>()
//    private var buttonTopConstraint: NSLayoutConstraint?
//    init<SheetContent: View, Content: View, FloatContent: View>(
//        sheetContent: SheetContent,
//        content: Content,
//        floatContent: FloatContent,
//        containerHolder: ContainerHolder
//    ) {
//        self.sheetContent = AnyView(sheetContent)
//        self.content = AnyView(content)
//        self.floatContent = AnyView(floatContent)
//        self.containerHolder = containerHolder
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) { fatalError("init(coder:) не реализован") }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupBackground()
//        setupContainer()
//        setupMainContent()
//        observeContainerPosition()
//        setupFloatButton()
//        move()
//    }
//    private func setupFloatButton() {
//        floatHosting = UIHostingController(rootView: floatContent)
//        guard let floatHosting = floatHosting else { return }
//        
//        
//        addChild(floatHosting)
//        fView.addSubview(floatHosting.view)
//
//        floatHosting.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            floatHosting.view.topAnchor.constraint(equalTo: fView.topAnchor),
//            floatHosting.view.bottomAnchor.constraint(equalTo: fView.bottomAnchor),
//            floatHosting.view.leadingAnchor.constraint(equalTo: fView.leadingAnchor),
//            floatHosting.view.trailingAnchor.constraint(equalTo: fView.trailingAnchor)
//        ])
//
//        floatHosting.didMove(toParent: self)
//        fView.layer.cornerRadius = 15
//            fView.layer.masksToBounds = true
//        view.addSubview(fView)
//        buttonTopConstraint = fView.topAnchor.constraint(equalTo: view.topAnchor, constant: 552)
//        NSLayoutConstraint.activate([
//            buttonTopConstraint!,
//            fView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            fView.widthAnchor.constraint(equalToConstant: 60),
//            fView.heightAnchor.constraint(equalToConstant: 60)
//        ])
//    }
//
//    
//    @objc
//    func move(){
//        containerHolder.containerPosition = ContainerPosition(top: 160, middle: nil, bottom: 160)
//        containerHolder.moveToBottom()
//    }
//    
//    
//    private func setupBackground() {
//        let hostingController = UIHostingController(rootView: content)
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        addChild(hostingController)
//        view.insertSubview(hostingController.view, at: 0)
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//        hostingController.didMove(toParent: self)
//        backgroundHosting = hostingController
//    }
//    
//    private func setupContainer() {
//        let layout = ContainerLayout()
//        layout.startPosition = .bottom
//        layout.positions = containerHolder.containerPosition
//        container = ContainerController(addTo: self, layout: layout)
//        container.delegate = self
//        container.view.cornerRadius = 24
//        container.view.addShadow()
//        containerHolder.container = container
//    }
//    
//    private func observeContainerPosition() {
//        containerHolder.$containerPosition
//            .sink { [weak self] newPositions in
//                guard let self = self else { return }
//                self.container.layout.positions = newPositions
//                self.container.view.setNeedsLayout()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func setupMainContent() {
//        let hosting = UIHostingController(rootView: sheetContent)
//        let scroll = UIScrollView()
//        hosting.view.translatesAutoresizingMaskIntoConstraints = false
//        hosting.view.backgroundColor = .clear
//        scroll.addSubview(hosting.view)
//        NSLayoutConstraint.activate([
//            hosting.view.topAnchor.constraint(equalTo: scroll.topAnchor),
//            hosting.view.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
//            hosting.view.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
//            hosting.view.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
//            hosting.view.widthAnchor.constraint(equalTo: scroll.widthAnchor)
//        ])
//        container.add(scrollView: scroll)
//        addChild(hosting)
//        hosting.didMove(toParent: self)
//        mainHosting = hosting
//        containerScrollView = scroll
//    }
//    
//
//    
//    func updateContent<MainContent: View, SheetContent: View, FloatContent: View>(
//        mainContent: MainContent,
//        sheetContent: SheetContent,
//        floatContent: FloatContent
//    ) {
//        mainHosting?.rootView = AnyView(mainContent)
//        sheetHosting?.rootView = AnyView(sheetContent)
//        if let floatHosting = floatHosting {
//            floatHosting.rootView = AnyView(floatContent)
//        }
//        
//        if let scroll = containerScrollView {
//            scroll.removeFromSuperview()
//            container.add(scrollView: scroll)
//        }
//        if let footer = containerFooterView {
//            footer.removeFromSuperview()
//            container.add(footerView: footer)
//        }
//        container.view.setNeedsLayout()
//        container.view.layoutIfNeeded()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        container.remove()
//        container = nil
//    }
//    
//    func containerControllerShadowClick(_ containerController: ContainerController) {}
//    func containerControllerRotation(_ containerController: ContainerController) {}
//    func containerControllerMove(_ containerController: ContainerController, position: CGFloat, type: ContainerMoveType, animation: Bool) {
//        buttonTopConstraint?.constant = position - 100
//        if animation {
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//        } else {
//            view.layoutIfNeeded()
//        }
//    }
//}
