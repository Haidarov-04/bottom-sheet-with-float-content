import UIKit
class ContainerControllerWrapper: UIViewController {
    private lazy var floatingButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(systemName: "list.dash"), for: .normal
        )

        button.addTarget(
            self,
            action: #selector(openSheet),
            for: .touchUpInside
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground.withAlphaComponent(0.95)
        button.layer.cornerRadius = 20.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4.0
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        view.backgroundColor = .systemMint
        view.addSubview(floatingButton)

        let buttonBottomConstraint = floatingButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -10
        )
        buttonBottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            buttonBottomConstraint,
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc
    private func openSheet() {
        let childViewController = ChildViewController()

        if let sheet = childViewController.sheetPresentationController {
            sheet.detents = [.small(), .medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }

        childViewController.isModalInPresentation = true
        childViewController.animateAlongside = { [self] _ in
            NSLayoutConstraint.activate([
                childViewController.view.topAnchor.constraint(equalTo: floatingButton.bottomAnchor, constant: 10)
            ])

            view.layoutIfNeeded()
        }
        present(childViewController, animated: true)
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static var smallIdentifier: Self {
        Self("small")
    }
}

extension UISheetPresentationController.Detent {
    static func small() -> UISheetPresentationController.Detent {
        .custom(identifier: .smallIdentifier) { context in
            context.maximumDetentValue * 0.15
        }
    }
}

class ChildViewController: UIViewController {
    var animateAlongside: ((any UIViewControllerTransitionCoordinatorContext) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        transitionCoordinator?.animate(alongsideTransition: { [self] context in
            animateAlongside?(context)
            animateAlongside = nil
        })
    }
}
