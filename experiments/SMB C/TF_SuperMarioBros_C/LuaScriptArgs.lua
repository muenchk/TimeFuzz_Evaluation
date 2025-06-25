-- calculates and returns the command line args for the PUT
-- Available Globals
--   input - Pointer to the current input
-- Available C++ functions
--   string         Input_GonvertToPython(InputPtr)        - converts the input sequence to a python list
--   int            Input_GetSequenceLength(InputPtr)      - returns the length of the input sequence
--   string         Input_GetSequenceFirst(InputPtr)       - returns the first entry of the input sequence
--   string         Input_GetSequenceNext(InputPtr)        - returns the next entry of the input sequence
--   string         Input_ConvertToString(InputPtr)        - returns the input as a single string
function GetScriptArgs()
    --str = Input_ConvertToString(input)
    --return str
    return ""
end