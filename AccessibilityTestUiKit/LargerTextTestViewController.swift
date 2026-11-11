//
//  LargerTextTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class LargerTextTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #2: Dynamic Type & Larger Text (UIKit)
    // TODO #2: Follow the inline instructions to detect Dynamic Type changes and adapt your layout when text reaches accessibility sizes.
    // LEARNING GOAL: Support all users by respecting their preferred text size, especially the larger accessibility categories.

    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!

    // TODO #2: Replace the placeholder return value with the Dynamic Type check below.
    // return traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    private var isAccessibilitySize: Bool {
        //return false
        return traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
        setupContent()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            setupContent()
        }
    }

    // MARK: - Setup
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
        // Current size indicator
        let sizeSection = createSizeIndicatorSection()
        contentStackView.addArrangedSubview(sizeSection)

        // Text style samples
        let stylesSection = createTextStylesSection()
        contentStackView.addArrangedSubview(stylesSection)

        // Icons + Text examples
        let iconsSection = createIconsWithTextSection()
        contentStackView.addArrangedSubview(iconsSection)

        // List items
        let listSection = createListSection()
        contentStackView.addArrangedSubview(listSection)

        // Buttons
        let buttonsSection = createButtonsSection()
        contentStackView.addArrangedSubview(buttonsSection)

        // Text wrapping demo
        let wrappingSection = createTextWrappingSection()
        contentStackView.addArrangedSubview(wrappingSection)
    }

    // MARK: - Section Creators
    private func createSizeIndicatorSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Current Text Size"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let sizeLabel = UILabel()
        let contentSize = traitCollection.preferredContentSizeCategory
        // TODO #2: Replace the placeholder text below with a message that checks `isAccessibilitySize` and shows the actual category.
        // Example: `sizeLabel.text = isAccessibilitySize ? "Accessibility Size Active" : "Standard Size"`
        // You can also show `contentSize` to help learners connect settings to code.
        sizeLabel.text = "Standard Size (placeholder)"
        sizeLabel.font = .preferredFont(forTextStyle: .title2)
        sizeLabel.adjustsFontForContentSizeCategory = true
        sizeLabel.textAlignment = .center
        sizeLabel.numberOfLines = 0
        container.addArrangedSubview(sizeLabel)

        let infoLabel = UILabel()
        infoLabel.text = "Change text size in Settings > Display & Text Size > Larger Text"
        infoLabel.font = .preferredFont(forTextStyle: .caption1)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.textColor = .secondaryLabel
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        container.addArrangedSubview(infoLabel)

        return container
    }

    private func createTextStylesSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Text Styles"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let styles: [(UIFont.TextStyle, String)] = [
            (.largeTitle, "Large Title"),
            (.title1, "Title 1"),
            (.title2, "Title 2"),
            (.headline, "Headline"),
            (.body, "Body"),
            (.callout, "Callout"),
            (.footnote, "Footnote"),
            (.caption1, "Caption")
        ]

        for (style, name) in styles {
            let label = UILabel()
            label.text = name
            label.font = .preferredFont(forTextStyle: style)
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            container.addArrangedSubview(label)
        }

        return container
    }

    private func createIconsWithTextSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Icons + Text (Adaptive Layout)"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        // These stack vertically at accessibility sizes, horizontally otherwise
        let item1 = createIconTextItem(icon: "heart.fill", text: "Favorites", color: .systemPink)
        container.addArrangedSubview(item1)

        let item2 = createIconTextItem(icon: "star.fill", text: "Starred", color: .systemYellow)
        container.addArrangedSubview(item2)

        let item3 = createIconTextItem(icon: "bell.fill", text: "Notifications", color: .systemRed)
        container.addArrangedSubview(item3)

        return container
    }

    private func createIconTextItem(icon: String, text: String, color: UIColor) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        // TODO #2: When `isAccessibilitySize` is true, switch this to a vertical layout for better readability.
        // Example:
        // if isAccessibilitySize {
        //     stackView.axis = .vertical
        //     stackView.alignment = .leading
        // }

        let iconView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconView.image = UIImage(systemName: icon, withConfiguration: config)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(iconView)

        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])

        return stackView
    }

    private func createListSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 0
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        container.backgroundColor = .secondarySystemGroupedBackground

        let titleContainer = UIView()
        titleContainer.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.text = "List Items (Responsive)"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -12)
        ])

        container.addArrangedSubview(titleContainer)

        let items = [
            ("envelope.fill", "Messages", "12 unread", UIColor.systemBlue),
            ("phone.fill", "Phone", "3 missed calls", UIColor.systemGreen),
            ("calendar", "Calendar", "5 events today", UIColor.systemRed)
        ]

        for item in items {
            let itemView = createListItem(icon: item.0, title: item.1, subtitle: item.2, color: item.3)
            container.addArrangedSubview(itemView)

            // Add divider
            let divider = UIView()
            divider.backgroundColor = .separator
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            container.addArrangedSubview(divider)
        }

        return container
    }

    private func createListItem(icon: String, title: String, subtitle: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        // TODO #2: As text grows, update this stack view to `.vertical` and `.leading` alignment when `isAccessibilitySize` is true.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)

        // Icon
        let iconView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconView.image = UIImage(systemName: icon, withConfiguration: config)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(iconView)

        // Text stack
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        textStack.addArrangedSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        textStack.addArrangedSubview(subtitleLabel)

        stackView.addArrangedSubview(textStack)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])

        return container
    }

    private func createButtonsSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Buttons (Adaptive Sizing)"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let button1 = createAdaptiveButton(title: "Primary Action", color: .systemBlue)
        container.addArrangedSubview(button1)

        let button2 = createAdaptiveButton(title: "Secondary Action", color: .systemGray)
        container.addArrangedSubview(button2)

        return container
    }

    private func createAdaptiveButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        return button
    }

    private func createTextWrappingSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Text Wrapping Demo"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let paragraphLabel = UILabel()
        paragraphLabel.text = "This is a longer text that demonstrates proper text wrapping at various text sizes. Notice how the text flows naturally and maintains readability regardless of your text size preference. This is achieved by using Dynamic Type and allowing the text to wrap across multiple lines."
        paragraphLabel.font = .preferredFont(forTextStyle: .body)
        paragraphLabel.adjustsFontForContentSizeCategory = true
        paragraphLabel.numberOfLines = 0
        paragraphLabel.textColor = .label

        // Add line spacing for better readability
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedText = NSMutableAttributedString(string: paragraphLabel.text!)
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        paragraphLabel.attributedText = attributedText

        container.addArrangedSubview(paragraphLabel)

        return container
    }
}

#Preview("Larger Text") {
    let vc = LargerTextTestViewController()
    vc.title = "Larger Text"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
