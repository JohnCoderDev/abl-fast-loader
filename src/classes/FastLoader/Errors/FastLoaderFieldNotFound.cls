class classes.FastLoader.Errors.FastLoaderFieldNotFound inherits Progress.Lang.AppError:
    constructor FastLoaderFieldNotFound(pFieldName as character):
        addMessage('it was not possible to find a field with name `' + pFieldName + '`', -5002).
    end constructor.
end class.
