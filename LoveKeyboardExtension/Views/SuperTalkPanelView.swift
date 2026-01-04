import UIKit

/// 超会说面板视图
class SuperTalkPanelView: UIView {

    // MARK: - 回调
    var onPhraseSelected: ((String) -> Void)?
    var onClose: (() -> Void)?

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

        let titleLabel = UILabel()
        titleLabel.text = "超会说"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        setupPhrases()
    }

    private func setupPhrases() {
        let phrases = ["早上好", "晚安", "我爱你", "想你了"]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            stack.heightAnchor.constraint(equalToConstant: 36)
        ])

        for phrase in phrases {
            let button = UIButton(type: .system)
            button.setTitle(phrase, for: .normal)
            button.backgroundColor = UIColor(white: 0.95, alpha: 1)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(phraseTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func phraseTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        onPhraseSelected?(text)
    }
}
