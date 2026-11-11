//
//  ViewController.swift (ContentViewController)
//  AccessibilityTestUiKit
//
//  Created by Kaushik Manian on 21/10/25.
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    // MARK: - EXERCISE TODO #7: Adaptive Layouts (UIKit)
    // TODO #7: Hide decorative content and adjust layouts when text reaches accessibility sizes to keep the list scannable.
    // LEARNING GOAL: Use Dynamic Type checks to decide which flourishes to show or hide.

    // MARK: - Properties
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var filteredFeatures: [AccessibilityFeature] = []
    private var groupedFeatures: [(category: AccessibilityCategory, features: [AccessibilityFeature])] = []

    private var isAccessibilitySize: Bool {
        return traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        updateFilteredFeatures(searchText: "")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Reload table when text size changes
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            // Rebuild the header too, since it shows/hides its description by text size
            tableView.tableHeaderView = createHeaderView()
            tableView.reloadData()
        }
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Accessibility"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Add subtitle using a custom view
        if #available(iOS 16.0, *) {
            // Use navigation bar title menu for iOS 16+
            navigationItem.title = "Accessibility"
        }
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search accessibility features"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground

        // Register cells
        tableView.register(AccessibilityFeatureCell.self, forCellReuseIdentifier: "FeatureCell")
        tableView.register(CategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: "CategoryHeader")

        // Add header view with app description
        let headerView = createHeaderView()
        tableView.tableHeaderView = headerView

        view.addSubview(tableView)
    }

    private func createHeaderView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.text = "iOS Nutrition Labels"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Just like food labels help you understand what's in your food, these labels help you understand what accessibility features are available in iOS."
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])

        // Hide description at accessibility sizes
        // TODO #7: At accessibility sizes, hide this decorative description so content fits better.
        // A hidden view still takes part in Auto Layout, so pin the container's bottom
        // to whichever label is the last visible one.
        descriptionLabel.isHidden = isAccessibilitySize
        let lastVisibleLabel = isAccessibilitySize ? titleLabel : descriptionLabel
        lastVisibleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true

        // Calculate size
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = containerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        containerView.frame = CGRect(origin: .zero, size: size)

        return containerView
    }

    // MARK: - Data Management
    private func updateFilteredFeatures(searchText: String) {
        if searchText.isEmpty {
            filteredFeatures = AccessibilityFeature.allFeatures
        } else {
            filteredFeatures = AccessibilityFeature.allFeatures.filter { feature in
                feature.name.localizedCaseInsensitiveContains(searchText) ||
                feature.shortDescription.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Group features by category
        groupedFeatures = []
        for category in AccessibilityCategory.allCases {
            let features = filteredFeatures.filter { $0.category == category }
            if !features.isEmpty {
                groupedFeatures.append((category: category, features: features))
            }
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedFeatures.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedFeatures[section].features.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? AccessibilityFeatureCell else {
            return UITableViewCell()
        }

        let feature = groupedFeatures[indexPath.section].features[indexPath.row]
        cell.configure(with: feature, isAccessibilitySize: isAccessibilitySize)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryHeader") as? CategoryHeaderView else {
            return nil
        }

        let category = groupedFeatures[section].category
        headerView.configure(with: category)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feature = groupedFeatures[indexPath.section].features[indexPath.row]
        let detailVC = AccessibilityDetailViewController(feature: feature)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        updateFilteredFeatures(searchText: searchText)
    }
}

#Preview("Feature List") {
    let vc = ViewController()
    vc.title = "Accessibility"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}

// MARK: - Custom Cell
class AccessibilityFeatureCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()

    // Switchable constraints for the adaptive layout (TODO #7)
    private var nameLeadingToIcon: NSLayoutConstraint!
    private var nameLeadingFlush: NSLayoutConstraint!
    private var descriptionBottom: NSLayoutConstraint!
    private var nameBottom: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        // Container view with rounded corners and shadow
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)

        // Name label
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Description label
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)

        nameLeadingToIcon = nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16)
        nameLeadingFlush = nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        descriptionBottom = descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        nameBottom = nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Default (normal text size) layout; configure(...) swaps these at accessibility sizes
            nameLeadingToIcon,
            descriptionBottom
        ])
    }

    func configure(with feature: AccessibilityFeature, isAccessibilitySize: Bool) {
        nameLabel.text = feature.name
        descriptionLabel.text = feature.shortDescription

        // TODO #7: When the text is huge, hide decorative pieces like the icon and description to save space.
        iconImageView.isHidden = isAccessibilitySize
        descriptionLabel.isHidden = isAccessibilitySize

        // Configure icon
        // TODO #7: Only show the icon when there's enough room; otherwise keep it hidden.
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconImageView.image = UIImage(systemName: feature.icon, withConfiguration: config)
        iconImageView.tintColor = feature.color

        // Adjust constraints based on accessibility size
        // TODO #7: Rework constraints for large text so the label can sit flush with the leading edge.
        // Deactivate before activating so cell reuse never leaves conflicting constraints.
        // Hidden views still count in Auto Layout, so the label must also pin to the bottom.
        if isAccessibilitySize {
            NSLayoutConstraint.deactivate([nameLeadingToIcon, descriptionBottom])
            NSLayoutConstraint.activate([nameLeadingFlush, nameBottom])
        } else {
            NSLayoutConstraint.deactivate([nameLeadingFlush, nameBottom])
            NSLayoutConstraint.activate([nameLeadingToIcon, descriptionBottom])
        }

        // Accessibility
        accessibilityLabel = feature.name
        accessibilityHint = "Double tap to view details about \(feature.name)"
    }
}

// MARK: - Category Header View
class CategoryHeaderView: UITableViewHeaderFooterView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(iconImageView)

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with category: AccessibilityCategory) {
        titleLabel.text = category.displayName
        titleLabel.textColor = category.color

        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        iconImageView.image = UIImage(systemName: category.icon, withConfiguration: config)
        iconImageView.tintColor = category.color
    }
}
