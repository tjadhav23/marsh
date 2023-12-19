//
//  ClaimContainerViewController.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 09/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class ClaimContainerViewController: UIViewController, FlexibleSteppedProgressBarDelegate {

    // MARK: - Properties

    private var currentStepIndex: Int = 0
    private var viewControllers: [UIViewController] = []
    var backgroundColor = UIColor(hexString: "#C2C2C2") // LIGHT Grey
    var progressColor = FontsConstant.shared.app_FontPrimaryColor
    var textColorHere = FontsConstant.shared.app_FontPrimaryColor

    private var progressBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // Customize the background color to red
        return view
    }()

    private var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!

    // Container view for embedded view controllers
    private let containerView: UIView = {
        let view = UIView()
        // Customize the container view appearance here
        return view
    }()

    // Bottom navigation view
    private let bottomNavigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // Customize the background color as needed

        // Back button
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Next button
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        // Add buttons to the bottom navigation view
        view.addSubview(backButton)
        view.addSubview(nextButton)

        // Customize the buttons' appearance and constraints here

        return view
    }()

    private let previousBtn: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = FontsConstant.shared.app_FontPrimaryColor // Use the UIColor directly
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.layer.borderColor = FontsConstant.shared.app_FontSecondryColor.cgColor // Use .cgColor to set the border color
        backButton.layer.borderWidth = 2
        backButton.layer.cornerRadius = cornerRadiusForView
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Set the font for the button title
        backButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: 14.0) // Adjust the size as needed

        // Create height and width constraints
        let heightConstraint = NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0)
        let widthConstraint = NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100.0)

        // Add constraints to the button
        backButton.addConstraints([heightConstraint, widthConstraint])

        return backButton
    }()
 
    private let nextButton: UIButton = {
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = FontsConstant.shared.app_FontPrimaryColor // Set the background color for the next button
        nextButton.setTitleColor(UIColor.white, for: .normal) // Set text color
        nextButton.layer.borderColor = FontsConstant.shared.app_FontSecondryColor.cgColor  // Set border color
        nextButton.layer.borderWidth = 2 // Set border width
        nextButton.layer.cornerRadius = cornerRadiusForView // Use your corner radius value
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        // Set the font for the button title
        nextButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: 14.0) // Adjust the size as needed

        // Create height and width constraints
        let heightConstraint = NSLayoutConstraint(item: nextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0)
        let widthConstraint = NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100.0)

        // Add constraints to the button
        nextButton.addConstraints([heightConstraint, widthConstraint])

        return nextButton
    }()

    // MARK: - Initialization

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showViewController(at: currentStepIndex)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor), hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButton()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Claim Data upload"
        menuButton.isHidden = true
        DispatchQueue.main.async() {
            menuButton.isHidden = true
        }
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        createClaimDetailsFormViewController()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(progressBarView)
        view.addSubview(containerView)
        //view.addSubview(bottomNavigationView)

        // Add AutoLayout constraints for progressBarView
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBarView.topAnchor.constraint(equalTo: view.topAnchor),
            progressBarView.heightAnchor.constraint(equalToConstant: 100.0), // Set the height to 100
        ])

        // Add AutoLayout constraints for the containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: progressBarView.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomNavigationView.topAnchor),
        ])

        // Customize bottomNavigationView
        bottomNavigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomNavigationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomNavigationView.heightAnchor.constraint(equalToConstant: 100.0), // Set the height to 100
        ])

        // Add AutoLayout constraints for the buttons inside bottomNavigationView
        bottomNavigationView.addSubview(previousBtn)
        bottomNavigationView.addSubview(nextButton)

        previousBtn.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            previousBtn.leadingAnchor.constraint(equalTo: bottomNavigationView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: bottomNavigationView.trailingAnchor, constant: -16),
            previousBtn.centerYAnchor.constraint(equalTo: bottomNavigationView.centerYAnchor), // Center vertically
            nextButton.centerYAnchor.constraint(equalTo: bottomNavigationView.centerYAnchor), // Center vertically
        ])

        // Set the nextButton as initially disabled with a gray background
        nextButton.isEnabled = false
        nextButton.backgroundColor = FontsConstant.shared.app_FontSecondryColor

        // Add the FlexibleSteppedProgressBar to progressBarView
        setupProgressBarWithDifferentDimensions()
    }

    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.addSubview(progressBarWithDifferentDimensions)

        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 0 // position from top for bar
        )

        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, constant: -80)
        widthConstraint.isActive = true

        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalTo: progressBarView.heightAnchor)

        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        progressBarWithDifferentDimensions.numberOfPoints = 3
        progressBarWithDifferentDimensions.lineHeight = 3
        progressBarWithDifferentDimensions.radius = 6
        progressBarWithDifferentDimensions.progressRadius = 11
        progressBarWithDifferentDimensions.progressLineHeight = 3
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 0
    }

    private func showViewController(at index: Int) {
        // Remove the current child view controller
        let currentViewController = viewControllers[currentStepIndex]
        currentViewController.willMove(toParentViewController: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParentViewController()

        // Add the new child view controller
        let newViewController = viewControllers[index]
        addChildViewController(newViewController)
        newViewController.view.frame = containerView.bounds
        containerView.addSubview(newViewController.view)
        newViewController.didMove(toParentViewController: self)

        // Update the current step index
        currentStepIndex = index

        // Hide or show the Previous button based on the current view controller
        if newViewController is ClaimDetailsFormViewController {
            previousBtn.isHidden = true
        } else {
            previousBtn.isHidden = false
        }
        let vc = ClaimDetailsFormViewController()
        vc.delegate = self
        createClaimDetailsFormViewController()
    }

    @objc private func nextButtonTapped() {
        if currentStepIndex < viewControllers.count - 1 {
            currentStepIndex += 1
        }
        showViewController(at: currentStepIndex)
        progressBarWithDifferentDimensions.completedTillIndex = currentStepIndex
    }

    @objc private func backButtonTapped() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
        showViewController(at: currentStepIndex)
        progressBarWithDifferentDimensions.completedTillIndex = currentStepIndex
    }

    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {

                case 0: return "Claims Details"
                case 1: return "Add"
                case 2: return "File Upload"
                default: return ""

                }
            }
        }
        return ""
    }

}

extension ClaimContainerViewController: ClaimDetailsFormDelegate {

    func selectionStatusDidChange(isSuccess: Bool) {
        // Upd"ate the Next button state based on isSuccess
     
        print("Inside selectionStatusDidChange")
        self.updateNextButtonState(isEnabled: isSuccess, backgroundColor: FontsConstant.shared.app_FontPrimaryColor)
    }

    func createClaimDetailsFormViewController() {//-> ClaimDetailsFormViewController {
        let claimDetailsFormViewController = ClaimDetailsFormViewController()
        claimDetailsFormViewController.delegate = self
        claimDetailsFormViewController.containerViewController = self // Set the reference to the container
        //return claimDetailsFormViewController
    }

    func updateNextButtonState(isEnabled: Bool, backgroundColor: UIColor) {
        print("Inside updateNextButtonState")
        if isEnabled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = FontsConstant.shared.app_FontPrimaryColor
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray // Set the button color to gray
        }
    }

}

