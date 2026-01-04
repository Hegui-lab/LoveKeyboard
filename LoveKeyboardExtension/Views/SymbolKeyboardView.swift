import UIKit

/// 符号键盘视图
class SymbolKeyboardView: UIView {

    // MARK: - 回调
    var onSymbolTapped: ((String) -> Void)?
    var onBackspace: (() -> Void)?

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
        backgroundColor = UIColor(white: 0.85, alpha: 1)

        let symbols = ["，", "。", "？", "！", "、", "：", "；"]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        for symbol in symbols {
            let button = UIButton(type: .system)
            button.setTitle(symbol, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(symbolTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func symbolTapped(_ sender: UIButton) {
        guard let symbol = sender.title(for: .normal) else { return }
        onSymbolTapped?(symbol)
    }
}
