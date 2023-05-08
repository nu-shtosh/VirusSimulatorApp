//
//  ViewController.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 04.05.2023.
//

import UIKit

final class ModulationViewController: UIViewController {

    // MARK: - Properties
    var groupSize = 0
    var infectionFactor = 0
    var recalculationPeriod = 0.0
    var matrix: [[Bool]] = [[]]

    // MARK: - Private Properties
    private var timer: Timer?
    private var seconds = 0

    private var matrixElements: Int {
        let rowCount = matrix.count
        let columnCount = matrix.first?.count ?? 0

        let totalCount = rowCount * columnCount
        return totalCount
    }

    private var greenElements: Int {
        var count = 0

            for row in matrix {
                for element in row {
                    if !element {
                        count += 1
                    }
                }
            }
            return count
    }

    private var redElements: Int {
        var count = 0

            for row in matrix {
                for element in row {
                    if element {
                        count += 1
                    }
                }
            }
            return count
    }

    private var cellScaleFactor = 1.0

    // MARK: - UI Elements
    // MARK: - Header
    private lazy var header: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var greenView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": \(matrixElements)"
        return label
    }()

    private lazy var redView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": \(redElements)"
        return label
    }()

    // MARK: - Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection =  .horizontal


        let collectionView = UICollectionView(
            frame: self.view.bounds,
            collectionViewLayout: layout
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "collectionCell")

        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true

        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Footer
    private lazy var footer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var startButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .systemBlue
        buttonConfiguration.title = "Start"
        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.addTarget(self,
                         action: #selector(startButtonDidTupped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var stopButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .systemRed
        buttonConfiguration.title = "Stop"
        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.addTarget(self,
                         action: #selector(stopButtonDidTupped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        print(infectionFactor)
        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private Methods
    // MARK: - Update View With Timer
    private func updateView() {
        if greenElements <= 0 {
            timer?.invalidate()
            timer = nil
        }
        replaceRandomNeighborsOfOneWithZero(matrix: matrix,
                                            withFactor: infectionFactor)
        greenLabel.text = ": \(greenElements)"
        redLabel.text = ": \(redElements)"
        self.collectionView.reloadData()
    }


    // MARK: - Change Item in Matrix
    private func replaceRandomNeighborsOfOneWithZero(matrix: [[Bool]],
                                                     withFactor factor: Int) {
        DispatchQueue.global(qos: .background).async {
        let numRows = matrix.count
        let numColumns = matrix[0].count

            for row in 0..<numRows {
                for column in 0..<numColumns {
                    if matrix[row][column] == true {
                        for _ in 0..<Int.random(in: 0...factor) {
                            let randomRow = Int.random(in: max(row-1, 0)...min(row+1, numRows-1))
                            let randomColumn = Int.random(in: max(column-1, 0)...min(column+1, numColumns-1))

                            DispatchQueue.main.async {
                                if matrix[randomRow][randomColumn] == false {
                                    self.matrix[randomRow][randomColumn] = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Update Timer
    private func updateTimerLabel() {
        let minutes = seconds / 60 * Int(recalculationPeriod)
        let seconds = seconds % 60 * Int(recalculationPeriod)
        timerLabel.text = "Pass Time: \(String(format: "%02d:%02d", minutes, seconds))"
    }

    @objc
    func startButtonDidTupped() {
        if timer == nil {
            DispatchQueue.global(qos: .background).async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.recalculationPeriod,
                                                  repeats: true) { timer in
                    self.seconds += 1
                    DispatchQueue.main.async {
                        self.updateView()
                        self.updateTimerLabel()
                    }
                }

                self.timer!.tolerance = 0.1
                let runLoop = RunLoop.current
                runLoop.add(self.timer!, forMode: .default)
                runLoop.run()
            }
            addRandomRedInMatrix(matrix)
        }
    }

    private func selectCell() {
        if timer == nil {
            DispatchQueue.global(qos: .background).async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.recalculationPeriod,
                                                  repeats: true) { timer in
                    self.seconds += 1
                    DispatchQueue.main.async {
                        self.updateView()
                        self.updateTimerLabel()
                    }
                }

                self.timer!.tolerance = 0.1
                let runLoop = RunLoop.current
                runLoop.add(self.timer!, forMode: .default)
                runLoop.run()
            }
        }
    }

    private func addRandomRedInMatrix(_ matrix: [[Bool]]) {
        DispatchQueue.global(qos: .background).async {
            let randomRow = Int.random(in: 0..<matrix.count)
            let randomColumn = Int.random(in: 0..<matrix[randomRow].count)


            DispatchQueue.main.async {
                if matrix[randomRow][randomColumn] == false {
                    self.matrix[randomRow][randomColumn] = true
                }
            }
        }
    }

    @objc
    func stopButtonDidTupped() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Setup View
extension ModulationViewController {
    private func setupMainView() {
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubviews(header, footer)
        header.addSubviews(greenView, greenLabel, redLabel, redView)
        footer.addSubviews(timerLabel, startButton, stopButton)
        view.addSubview(collectionView)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // Header
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),

            greenView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            greenView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            greenView.widthAnchor.constraint(equalToConstant: 30),
            greenView.heightAnchor.constraint(equalToConstant: 30),

            greenLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            greenLabel.leadingAnchor.constraint(equalTo: greenView.trailingAnchor, constant: 16),

            redLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            redLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),

            redView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            redView.trailingAnchor.constraint(equalTo: redLabel.leadingAnchor, constant: -16),
            redView.widthAnchor.constraint(equalToConstant: 30),
            redView.heightAnchor.constraint(equalToConstant: 30),

            // Collection view
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footer.topAnchor),

            // Footer
            footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: 60),

            timerLabel.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 16),

            startButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            startButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -16),
            startButton.widthAnchor.constraint(equalToConstant: 70),
            startButton.heightAnchor.constraint(equalToConstant: 40),

            stopButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            stopButton.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -16),
            stopButton.widthAnchor.constraint(equalToConstant: 60),
            stopButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        title = "Modulation"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(plus))
        let minusButton = UIBarButtonItem(image: UIImage(systemName: "minus"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(minus))
        navigationItem.rightBarButtonItems = [plusButton, minusButton]
    }

    // MARK: - Scale Methods
    @objc func plus() {
        self.cellScaleFactor += 0.1
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }

    @objc func minus() {
        if cellScaleFactor > 0.1 {
            self.cellScaleFactor -= 0.1
        }
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
}

// MARK: - Collection View Delegate And DataSource
extension ModulationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return matrix.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return matrix.first?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",
                                                      for: indexPath as IndexPath)
        let item = matrix[indexPath.section][indexPath.row]
        if !item  {
            cell.backgroundColor = .systemGreen
        } else {
            cell.backgroundColor = .systemRed
        }
        cell.layer.cornerRadius = cell.frame.width / 2
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
            self.selectCell()
            let item = self.matrix[indexPath.section][indexPath.row]
            DispatchQueue.main.async {

                if item {
                    self.matrix[indexPath.section][indexPath.row].toggle()
                } else {
                    self.matrix[indexPath.section][indexPath.row].toggle()
                }
            }
        }
        collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
}

// MARK: - Collection View Delegate Flow Layout
extension ModulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch matrixElements {
        case 0...100:
            let width = 40 * cellScaleFactor
            let height = 40 * cellScaleFactor
            return CGSize(width: width, height: height)
        case 100...300:
            let width = 23 * cellScaleFactor
            let height = 23 * cellScaleFactor
            return CGSize(width: width, height: height)
        case 300...600:
            let width = 15 * cellScaleFactor
            let height = 15 * cellScaleFactor
            return CGSize(width: width, height: height)
        case 600...900:
            let width = 11 * cellScaleFactor
            let height = 11 * cellScaleFactor
            return CGSize(width: width, height: height)
        default:
            let width = 20 * cellScaleFactor
            let height = 20 * cellScaleFactor
            return CGSize(width: width, height: height)
        }
    }
}
