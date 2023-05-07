//
//  ViewController.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 04.05.2023.
//

import UIKit

class ModulationViewController: UIViewController {

    // MARK: - Properties
    var groupSize: Int = 0
    var infectionFactor: Int = 0
    var timer: Double = 0

    var updateTimer: Timer?

    var matrix: [[Bool]] = [[]]

    var green: Int = 0
    var red: Int = 0

    var matrixElements: Int {
        let rowCount = matrix.count
        let columnCount = matrix.first?.count ?? 0

        let totalCount = rowCount * columnCount
        return totalCount
    }
    
    let standardCellSize = CGSize(width: 100, height: 100)
    let enlargedCellSize = CGSize(width: 200, height: 200)

    var cellScaleFactor = 1.0

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
        label.text = ": 0"
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
        label.text = ": 0"
        return label
    }()

    // MARK: - Collection
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
//        layout.itemSize = CGSize(width: 30, height: 30)

        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: self.view.bounds,
            collectionViewLayout: layout
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "collectionCell")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        red = 0
        green = matrixElements
        if updateTimer == nil {
            let timer = Timer(timeInterval: self.timer,
                            target: self,
                            selector: #selector(updateView),
                            userInfo: nil,
                            repeats: true)
          RunLoop.current.add(timer, forMode: .common)
          timer.tolerance = 0.1

          self.updateTimer = timer
        }
        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
    }

    // MARK: - Update View With Timer
    @objc func updateView() {
        if green == 0 {
            updateTimer?.invalidate()
            updateTimer = nil
        }
        replaceRandomNeighborsOfOneWithZero(matrix: &matrix, withFactor: infectionFactor)
        greenLabel.text = ": \(green)"
        redLabel.text = ": \(red)"
        self.collectionView.reloadData()
    }


    // MARK: - Change Item in Matrix
    private func replaceRandomNeighborsOfOneWithZero(matrix: inout [[Bool]], withFactor factor: Int) {
        let numRows = matrix.count
        let numColumns = matrix[0].count

        for row in 0..<numRows {
            for column in 0..<numColumns {
                if matrix[row][column] == true {
                    for _ in 0..<Int.random(in: 0..<factor) {
                        let randomRow = Int.random(in: max(row-1, 0)...min(row+1, numRows-1))
                        let randomColumn = Int.random(in: max(column-1, 0)...min(column+1, numColumns-1))

                        if matrix[randomRow][randomColumn] == false {
                            green -= 1
                            red += 1
                            matrix[randomRow][randomColumn] = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Setup View
extension ModulationViewController {
    private func setupMainView() {
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubviews(header, footer)
        header.addSubviews(greenView, greenLabel, redLabel, redView)
        view.addSubview(collectionView)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // header
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),

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

            // collection view
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footer.topAnchor),

            // footer
            footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        title = "Modulation"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plus))
        let minusButton = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(minus))
        navigationItem.rightBarButtonItems = [plusButton, minusButton]
    }

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
        print(indexPath)
        let item = matrix[indexPath.section][indexPath.row]
        if item {
            green += 1
            matrix[indexPath.section][indexPath.row].toggle()
            red -= 1
        } else {
            green -= 1
            matrix[indexPath.section][indexPath.row].toggle()
            red += 1
        }
        collectionView.reloadData()
    }
}

extension ModulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 30 * cellScaleFactor
        let height = 30 * cellScaleFactor
        return CGSize(width: width, height: height)
    }
}
