//
//  DarkInterfaceTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class DarkInterfaceTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #3: Dark Mode & Contrast (UIKit)
    // TODO #3: Make this screen adapt to the current interface style and use semantic colors so it looks great in light and dark modes.
    // LEARNING GOAL: Detect appearance changes with trait collections and choose the right UIKit semantic colours.

    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
        setupContent()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            setupContent()
        }
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentStackView() {
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupContent() {
        // Current mode indicator
        let modeSection = createModeIndicator()
        contentStackView.addArrangedSubview(modeSection)

        // Semantic colors
        let colorsSection = createSemanticColorsSection()
        contentStackView.addArrangedSubview(colorsSection)

        // Background layers
        let backgroundsSection = createBackgroundLayersSection()
        contentStackView.addArrangedSubview(backgroundsSection)

        // UI elements
        let elementsSection = createUIElementsSection()
        contentStackView.addArrangedSubview(elementsSection)

        // Color contrast info
        let infoSection = createInfoSection()
        contentStackView.addArrangedSubview(infoSection)
    }

    private func createModeIndicator() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Current Mode"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let modeLabel = UILabel()
        // TODO #3: Replace this placeholder with logic that checks `traitCollection.userInterfaceStyle`.
        // Try showing "Dark Mode" or "Light Mode" and pair it with a SF Symbol like sun or moon.
        // Example:
        let isDark = traitCollection.userInterfaceStyle == .dark
        modeLabel.text = isDark ? "Dark Mode" : "Light Mode"
        //modeLabel.text = "Interface style goes here"
        modeLabel.font = .preferredFont(forTextStyle: .title2)
        modeLabel.adjustsFontForContentSizeCategory = true
        modeLabel.textAlignment = .center
        container.addArrangedSubview(modeLabel)

        let infoLabel = UILabel()
        infoLabel.text = "Toggle in Settings > Display & Brightness"
        infoLabel.font = .preferredFont(forTextStyle: .caption1)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.textColor = .secondaryLabel
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        container.addArrangedSubview(infoLabel)

        return container
    }

    private func createSemanticColorsSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Semantic Colors"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        // TODO #3: Swap these placeholders with the semantic colours that best represent each case.
        let colors: [(UIColor, String)] = [
            //(.black, "Primary Text (placeholder)")
            //.label, .secondaryLabel, .tertiaryLabel → uncomment when you're ready
            (.label, "Primary Text"),
            (.secondaryLabel, "Secondary Text"),
            (.tertiaryLabel, "Tertiary Text")
        ]

        for (color, name) in colors {
            let row = createColorRow(color: color, name: name)
            container.addArrangedSubview(row)
        }

        return container
    }

    private func createColorRow(color: UIColor, name: String) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center

        let colorBox = UIView()
        colorBox.backgroundColor = color
        colorBox.layer.cornerRadius = 8
        colorBox.layer.borderWidth = 1
        colorBox.layer.borderColor = UIColor.separator.cgColor
        colorBox.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(colorBox)

        let label = UILabel()
        label.text = name
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        // TODO #3: Once you swap in semantic colours, decide whether to keep the sample colour here or rely on `.label` for contrast.
        label.textColor = .label
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            colorBox.widthAnchor.constraint(equalToConstant: 40),
            colorBox.heightAnchor.constraint(equalToConstant: 40)
        ])

        return stackView
    }

    private func createBackgroundLayersSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Background Layers"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        // TODO #3: Replace these placeholder values with the appropriate semantic backgrounds (systemBackground, secondarySystemBackground, etc.).
        let backgrounds: [(UIColor, String)] = [
//            (.white, "Primary Background (placeholder)"),
//            (.lightGray, "Secondary Background (placeholder)"),
//            (.darkGray, "Tertiary Background (placeholder)")
            (.white, "Primary Background"),
            (.lightGray, "Secondary Background"),
            (.darkGray, "Tertiary Background")
        ]

        for (bgColor, name) in backgrounds {
            let box = createBackgroundBox(color: bgColor, name: name)
            container.addArrangedSubview(box)
        }

        return container
    }

    private func createBackgroundBox(color: UIColor, name: String) -> UIView {
        let box = UIView()
        box.backgroundColor = color
        box.layer.cornerRadius = 8
        box.layer.borderWidth = 1
        box.layer.borderColor = UIColor.separator.cgColor
        box.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = name
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: box.centerYAnchor),
            box.heightAnchor.constraint(equalToConstant: 60)
        ])

        return box
    }

    private func createUIElementsSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "UI Elements"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let button = UIButton(type: .system)
        button.setTitle("Example Button", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        container.addArrangedSubview(button)

        let card = createExampleCard()
        container.addArrangedSubview(card)

        return container
    }

    private func createExampleCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = "Example Card"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(titleLabel)

        let descLabel = UILabel()
        descLabel.text = "Cards adapt their appearance in dark mode"
        descLabel.font = .preferredFont(forTextStyle: .body)
        descLabel.adjustsFontForContentSizeCategory = true
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        stackView.addArrangedSubview(descLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        return card
    }

    private func createInfoSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "About Dark Mode"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let infoLabel = UILabel()
        infoLabel.text = "Dark mode reduces eye strain in low-light conditions. All colors shown use semantic colors that automatically adapt to the current appearance."
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0
        container.addArrangedSubview(infoLabel)

        return container
    }
}

#Preview("Dark Interface") {
    let vc = DarkInterfaceTestViewController()
    vc.title = "Dark Interface"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
