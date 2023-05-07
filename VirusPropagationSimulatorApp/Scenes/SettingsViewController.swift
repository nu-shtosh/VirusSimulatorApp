//
//  SettingsViewController.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 04.05.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Group Size
    private lazy var groupSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Group Size"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "100"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    // MARK: - Infection Factor
    private lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Infection Factor"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "3"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    // MARK: - Timer
    private lazy var recalculationPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Recalculation Period"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var recalculationPeriodTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "1"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    // MARK: - Alert Message
    private lazy var alertMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You must to add something in Text Fields!"
        label.textColor = .red
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isHidden = true
        return label
    }()

    // MARK: - Start Button
    private lazy var startModulationButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .systemBlue
        buttonConfiguration.title = "Start Modulation"
        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.addTarget(self,
                         action: #selector(startModulationButtonDidTupped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: -  View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }

    // MARK: - Start Button Did Tapped
    @objc func startModulationButtonDidTupped() {
        if let groupSize = Int(groupSizeTextField.text ?? "0"),
           let infectionFactor = Int(infectionFactorTextField.text ?? "0"),
           let recalculationPeriod = Double(recalculationPeriodTextField.text ?? "0"),
           groupSize > 0,
           infectionFactor > 0,
           recalculationPeriod > 0 {
            let modulationVC = ModulationViewController()

            modulationVC.groupSize = groupSize
            modulationVC.infectionFactor = infectionFactor
            modulationVC.recalculationPeriod = recalculationPeriod

            modulationVC.matrix = makeMatrix(groupSize)

            self.groupSizeTextField.text = nil
            self.infectionFactorTextField.text = nil
            self.recalculationPeriodTextField.text = nil

            self.alertMessage.isHidden = true
            navigationController?.pushViewController(modulationVC, animated: true)
        } else {
            startModulationButton.shake()
            alertMessage.isHidden = false
        }
    }

    /// Создает правильную матрицу из какого то числа
    func makeMatrix(_ number: Int) -> [[Bool]] {
        let rows = sqrt(Double(number))
        let columns = sqrt(Double(number))
        return Array(repeating: Array(repeating: false,
                                      count: Int(columns)),
                     count: Int(rows))
    }
}

// MARK: - Setup Main View
extension SettingsViewController {
    private func setupMainView() {
        view.backgroundColor = .systemGray6
        setupNavigationBar()
        view.addSubviews(groupSizeLabel,
                         groupSizeTextField,
                         infectionFactorLabel,
                         infectionFactorTextField,
                         recalculationPeriodLabel,
                         recalculationPeriodTextField,
                         startModulationButton,
                         alertMessage)
        setupConstraints()
    }

    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //Group Size
            groupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupSizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 10),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 40),

            // Factor
            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infectionFactorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 10),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 40),

            // Timer
            recalculationPeriodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            recalculationPeriodLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            recalculationPeriodLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            recalculationPeriodTextField.topAnchor.constraint(equalTo: recalculationPeriodLabel.bottomAnchor, constant: 10),
            recalculationPeriodTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            recalculationPeriodTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            recalculationPeriodTextField.heightAnchor.constraint(equalToConstant: 40),

            startModulationButton.topAnchor.constraint(equalTo: recalculationPeriodTextField.bottomAnchor, constant: 30),
            startModulationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            startModulationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            startModulationButton.heightAnchor.constraint(equalToConstant: 40),

            // Alert Message
            alertMessage.topAnchor.constraint(equalTo: startModulationButton.bottomAnchor, constant: 10),
            alertMessage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            alertMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
