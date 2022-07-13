//
//  ValidationRule.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class ValidationRule {
    func isValid(_ param: Int?) -> Bool {
        return param != nil
    }

    func isValid(_ param: String?) -> Bool {
        return param != nil
    }
}

class SmsIdRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! > 0
    }
}

class FullSmsRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        let paramLen = param!.count

        return !isEmpty && paramLen < 300
    }
}

class DisplayNameRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        return !isEmpty
    }
}

class SenderRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        return !isEmpty
    }
}

class SmsDateRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param!.isDateFormat
    }
}

class SmsTypeRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! > -1 && param! < 4
    }
}

class TitleRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        return !isEmpty
    }
}

class RegIdRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! > 0
    }
}

class RepSenderRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        return !isEmpty
    }
}

class RegExpressionRule: ValidationRule {
    override func isValid(_ param: String?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        let isEmpty = param!.isEmpty
        return !isEmpty
    }
}

class CardNameRule: ValidationRule {}

class CardTypeRule: ValidationRule {}

class CardSubTypeRule: ValidationRule {}

class CardNumRule: ValidationRule {}

class SpentMoneyRule: ValidationRule {}

class SpentDateRule: ValidationRule {}

class KeywordRule: ValidationRule {}

class InstallmentCountRule: ValidationRule {}

class DwTypeRule: ValidationRule {}

class IsCancelRule: ValidationRule {}

class CurrencyRule: ValidationRule {}

class BalanceRule: ValidationRule {}

class UserNameRule: ValidationRule {}

class IsDeleteRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! == 0 || param! == 1
    }
}

class PriorityRule: ValidationRule {}

class SenderIdRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! > 0
    }
}

class RepSenderIdRule: ValidationRule {
    override func isValid(_ param: Int?) -> Bool {
        let isValid = super.isValid(param)
        if !isValid {
            return false
        }

        return param! > 0
    }
}
