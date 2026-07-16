import UIKit
import TDLibKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI Elements
    private let phoneTextField = UITextField()
    private let codeTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let statusLabel = UILabel()

    private var isCodeRequested = false
    private var phoneNumber: String = ""
    private var tdLibClient = TDLibClient.shared

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupTDLib()
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Настройка полей ввода и кнопки
        let stackView = UIStackView(arrangedSubviews: [phoneTextField, codeTextField, loginButton, statusLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])

        phoneTextField.placeholder = "Введите номер телефона"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self

        codeTextField.placeholder = "Код подтверждения"
        codeTextField.borderStyle = .roundedRect
        codeTextField.isHidden = true
        codeTextField.keyboardType = .numberPad
        codeTextField.delegate = self

        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)

        statusLabel.text = "Введите номер"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.textColor = .gray
    }

    // MARK: - TDLib Setup
    private func setupTDLib() {
        // Устанавливаем API ID и HASH (публичные, можно использовать известные)
        tdLibClient.setApiId(apiId: 2040, apiHash: "b18441a1ff607e10a989891a5462e627") // пример, можно заменить на свои
    }

    // MARK: - Actions
    @objc private func loginAction() {
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            statusLabel.text = "Введите номер"
            return
        }

        if !isCodeRequested {
            // Запрос кода
            phoneNumber = phone
            tdLibClient.requestAuthCode(phoneNumber: phoneNumber) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.isCodeRequested = true
                        self?.codeTextField.isHidden = false
                        self?.loginButton.setTitle("Подтвердить", for: .normal)
                        self?.statusLabel.text = "Код отправлен"
                    case .failure(let error):
                        self?.statusLabel.text = "Ошибка: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            // Подтверждение кода
            guard let code = codeTextField.text, !code.isEmpty else {
                statusLabel.text = "Введите код"
                return
            }
            tdLibClient.checkAuthCode(code: code) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.statusLabel.text = "Авторизация успешна!"
                        // Переход к списку чатов (пока заглушка)
                        self?.showChats()
                    case .failure(let error):
                        self?.statusLabel.text = "Ошибка кода: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    private func showChats() {
        // Пока просто алерт
        let alert = UIAlertController(title: "Успех", message: "Вы вошли в Telegram", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
