//
//  FilterPopViewController.swift
//  MovieExplorerTask
//
//  Created by Apple on 26/07/25.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func didApplyFilter(sortBy: String, genre: String?, year: String?)
}

class FilterView: UIView {

    weak var delegate: FilterViewDelegate?

    private let containerView = UIView()
    
    private let sortSegmented: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Popularity", "Rating"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let genrePicker = UIPickerView()
    private let yearPicker = UIPickerView()

    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private let genres = ["All", "Action", "Comedy", "Drama", "Horror"]
    private let years = (1980...2025).reversed().map { "\($0)" }
    
    var selectedGenre: String = "All"
    var selectedYear: String = "All"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)

        // Container View
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        genrePicker.dataSource = self
        genrePicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.delegate = self

        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        [sortSegmented, genrePicker, yearPicker, applyButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            sortSegmented.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            sortSegmented.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            genrePicker.topAnchor.constraint(equalTo: sortSegmented.bottomAnchor, constant: 16),
            genrePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            genrePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            genrePicker.heightAnchor.constraint(equalToConstant: 100),

            yearPicker.topAnchor.constraint(equalTo: genrePicker.bottomAnchor, constant: 16),
            yearPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            yearPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            yearPicker.heightAnchor.constraint(equalToConstant: 100),

            applyButton.topAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: 16),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 150),
            applyButton.heightAnchor.constraint(equalToConstant: 44),

            closeButton.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 8),
            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func applyFilter() {
        let sort = sortSegmented.selectedSegmentIndex == 0 ? "popularity.desc" : "vote_average.desc"
        let genre = selectedGenre == "All" ? "" : selectedGenre
        let year = selectedYear == "All" ? "" : selectedYear
        delegate?.didApplyFilter(sortBy: sort, genre: genre, year: year)
        dismiss()
    }

    @objc private func dismiss() {
        self.removeFromSuperview()
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !containerView.frame.contains(location) {
            dismiss()
        }
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension FilterView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == genrePicker ? genres.count : years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView == genrePicker ? genres[row] : years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePicker {
            selectedGenre = genres[row]
        } else {
            selectedYear = years[row]
        }
    }
}

