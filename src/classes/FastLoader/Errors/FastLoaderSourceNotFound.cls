class classes.FastLoader.Errors.FastLoaderSourceNotFound inherits Progress.Lang.AppError:
    constructor FastLoaderSourceNotFound(pName as character):
        addMessage('source with name `' + pName + '` was not found', -5000).
    end constructor.    
end class.
