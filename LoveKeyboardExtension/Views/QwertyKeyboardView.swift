import UIKit

/// QWERTY键盘视图
class QwertyKeyboardView: UIView {

    // MARK: - 回调
    var onKeyTapped: ((String) -> Void)?
    var onBackspace: (() -> Void)?
    var onReturn: (() -> Void)?
    var onSpace: (() -> Void)?
    var onShift: (() -> Void)?

    // MARK: - 状态
    private var isShifted = false

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
        setupKeyboardRows()
    }

    private func setupKeyboardRows() {
        let rows = [
            ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
            ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
            ["z", "x", "c", "v", "b", "n", "m"]
        ]

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        for row in rows {
            let rowStack = createRowStack(keys: row)
            mainStack.addArrangedSubview(rowStack)
        }

        let bottomRow = createBottomRow()
        mainStack.addArrangedSubview(bottomRow)
    }

    private func createRowStack(keys: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually

        for key in keys {
            let button = createKeyButton(title: key)
            stack.addArrangedSubview(button)
        }
        return stack
    }

    private func createKeyButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
        return button
    }

    private func createBottomRow() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4

        let spaceButton = UIButton(type: .system)
        spaceButton.setTitle("空格", for: .normal)
        spaceButton.backgroundColor = .white
        spaceButton.layer.cornerRadius = 5
        spaceButton.addTarget(self, action: #selector(spaceTapped), for: .touchUpInside)

        let backspaceButton = UIButton(type: .system)
        backspaceButton.setTitle("⌫", for: .normal)
        backspaceButton.backgroundColor = .lightGray
        backspaceButton.layer.cornerRadius = 5
        backspaceButton.addTarget(self, action: #selector(backspaceTapped), for: .touchUpInside)

        stack.addArrangedSubview(spaceButton)
        stack.addArrangedSubview(backspaceButton)

        spaceButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.7).isActive = true
        return stack
    }

    // MARK: - 事件处理
    @objc private func keyTapped(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }
        onKeyTapped?(key)
    }

    @objc private func spaceTapped() {
        onSpace?()
    }

    @objc private func backspaceTapped() {
        onBackspace?()
    }
}
