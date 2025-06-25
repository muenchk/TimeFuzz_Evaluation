-- calculates and returns the command line args for the PUT
-- Available Globals
--   input - Pointer to the current input
-- Available C++ functions
--   string         Input_GonvertToPython(InputPtr)        - converts the input sequence to a python list
--   int            Input_GetSequenceLength(InputPtr)      - returns the length of the input sequence
--   string         Input_GetSequenceFirst(InputPtr)       - returns the first entry of the input sequence
--   string         Input_GetSequenceNext(InputPtr)        - returns the next entry of the input sequence
function GetCmdArgsReplay()
    str = ""
    ascii = 1
    length = Input_GetSequenceLength(input)
    if (length > 0) then
        length = length -1
        seq = Input_GetSequenceFirst(input)
        if (string.match(seq, "a")) then
            ascii = ascii + 2
        end
        if (string.match(seq, "b")) then
            ascii = ascii + 4
        end
        if (string.match(seq, "u")) then
            ascii = ascii + 8
        end
        if (string.match(seq, "d")) then
            ascii = ascii + 16
        end
        if (string.match(seq, "l")) then
            ascii = ascii + 32
        end
        if (string.match(seq, "r")) then
            ascii = ascii + 64
        end
        str = str .. string.char(ascii)

        while (length > 0) do
            ascii = 1
            length = length -1
            seq = Input_GetSequenceNext(input)
            if (string.match(seq, "a")) then
                ascii = ascii + 2
            end
            if (string.match(seq, "b")) then
                ascii = ascii + 4
            end
            if (string.match(seq, "u")) then
                ascii = ascii + 8
            end
            if (string.match(seq, "d")) then
                ascii = ascii + 16
            end
            if (string.match(seq, "l")) then
                ascii = ascii + 32
            end
            if (string.match(seq, "r")) then
                ascii = ascii + 64
            end
            str = str .. string.char(ascii)
        end
    else
    end
    return " 33 " .. string.len(str) .. " trace video"
end