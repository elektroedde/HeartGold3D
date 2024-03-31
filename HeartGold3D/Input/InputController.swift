import GameController

class InputController {
    static let shared = InputController()

    var keysPressed: Set<GCKeyCode> = []

    var curController: GCController?
    private var gamePadCurrent: GCController?
    private var gamePadLeft: GCControllerDirectionPad?
    private var gamePadRight: GCControllerDirectionPad?

    var flyUp = false
    var flyDown = false
    var cameraX: Float = 0
    var cameraY: Float = 0
    var positionX: Float = 0
    var positionY: Float = 0

    init() {
        let center = NotificationCenter.default
        center.addObserver(
            forName: .GCKeyboardDidConnect,
            object: nil,
            queue: nil) { notification in
                let keyboard = notification.object as? GCKeyboard
                keyboard?.keyboardInput?.keyChangedHandler
                    = { _, _, keyCode, pressed in
                        if pressed {
                            self.keysPressed.insert(keyCode)
                        } else {
                            self.keysPressed.remove(keyCode)
                        }
                    }
            }

        setupGameController()

        #if os(macOS)
            NSEvent.addLocalMonitorForEvents(
                matching: [.keyUp, .keyDown]) { _ in nil }
        #endif
    }

    func registerGameController(_ gameController: GCController) {
        var buttonX: GCControllerButtonInput?
        var buttonCircle: GCControllerButtonInput?
        var buttonSquare: GCControllerButtonInput?
        var buttonTriangle: GCControllerButtonInput?
        var rightTrigger: GCControllerButtonInput?
        var leftTrigger: GCControllerButtonInput?

        if let gamepad = gameController.extendedGamepad {
            gamePadLeft = gamepad.leftThumbstick
            gamePadRight = gamepad.rightThumbstick
            buttonX = gamepad.buttonA
            buttonCircle = gamepad.buttonB
            buttonSquare = gamepad.buttonX
            buttonTriangle = gamepad.buttonY
            rightTrigger = gamepad.rightTrigger
            leftTrigger = gamepad.leftTrigger
        }

        buttonX?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("X button pressed")
            
        }

        buttonCircle?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("Circle button pressed")
        }

        buttonTriangle?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("Triangle button pressed")
        }

        buttonSquare?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("Square button pressed")
        }

        rightTrigger?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("Right trigger pressed")
            if pressed {
                self.flyUp = true
            } else {
                self.flyUp = false
            }
        }
        
        leftTrigger?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) in

            print("Right trigger pressed")
            if pressed {
                self.flyDown = true
            } else {
                self.flyDown = false
            }
        }

        gamePadLeft?.valueChangedHandler = { _, xValue, yValue in
//            print("\(xValue) and \(yValue)")
            self.positionX = xValue
            self.positionY = yValue
        }

        gamePadRight?.valueChangedHandler = { _, yValue, xValue in
            self.cameraX = xValue
            self.cameraY = yValue
        }
    }

    func setupGameController() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)

        guard let controller = GCController.controllers().first else {
            return
        }
        registerGameController(controller)
    }

    @objc
    func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }
        registerGameController(gameController)
    }
}
