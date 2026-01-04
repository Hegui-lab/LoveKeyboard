import UIKit

// MARK: - CandidateBarViewDelegate协议
protocol CandidateBarViewDelegate: AnyObject {
    func candidateBarDidSelectCandidate(_ candidate: String)
}

/// 候选词栏视图 - 显示拼音输入的候选词
class CandidateBarView: UIView {

    // MARK: - Delegate
    weak var delegate: CandidateBarViewDelegate?

    // MARK: - UI组件
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI设置
    private func setupUI() {
        backgroundColor = .white

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }

    // MARK: - 公共方法
    func updateCandidates(_ candidates: [String], pinyin: String = "") {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 如果有拼音，先显示拼音
        if !pinyin.isEmpty {
            let pinyinLabel = UILabel()
            pinyinLabel.text = pinyin
            pinyinLabel.font = .systemFont(ofSize: 14)
            pinyinLabel.textColor = .gray
            stackView.addArrangedSubview(pinyinLabel)
        }

        for candidate in candidates {
            let button = UIButton(type: .system)
            button.setTitle(candidate, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            button.addTarget(self, action: #selector(candidateTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc private func candidateTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        delegate?.candidateBarDidSelectCandidate(text)
    }
}
