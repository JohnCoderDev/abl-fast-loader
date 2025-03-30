class classes.FastLoader.Errors.FastLoaderMethodNotImplemented inherits Progress.Lang.AppError:
    constructor FastLoaderMethodNotImplemented(pObject as Progress.Lang.Object, pArgumentType as character):
        addMessage("fast loader method receiving argument of type `" + pArgumentType + "`"
            + " is not implemented for the class `" + pObject:getClass():typeName + "`",
            -5001
        ).    
    end constructor.
    
    constructor FastLoaderMethodNotImplemented(pObject as Progress.Lang.Object, pArgumentType as character, pMethodName as character):
        addMessage("fast loader method receiving argument of type `" + pArgumentType + "`"
            + " is not implemented for the method `" + pMethodName + "` in the class `" + pObject:getClass():typeName + "`",
            -5001
        ).    
    end constructor.
end class.
