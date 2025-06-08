-- Determines the result of a test
-- Available Globals
--   input - Pointer to the current input
-- Available Functions
--   string         Input_ConvertToPython(InputPtr)                     - converts the input sequence to a python list
--   boolean        Input_IsTrimmed(InputPtr)                           - returns whether the executed input sequence is smaller than the generated
--   void           Input_Trim(InputPtr, int length)                    - trims the input sequence to [length] elements
--   nanoseconds    Input_GetExecutionTime(InputPtr)                    - returns the runtime of the PUT
--   int            Input_GetExitCode(InputPtr)                         - returns the exitcode of the PUT
--   int            Input_GetSequenceLength(InputPtr)                   - returns the length of the input sequence
--   string         Input_GetSequenceFirst(InputPtr)                    - returns the first entry of the input sequence
--   string         Input_GetSequenceNext(InputPtr)                     - returns the next entry of the input sequence
--   int            Input_GetExitReason(InputPtr)                       - returns the reason for PUT exit
--                  -- 0        - PUT still running
--                  -- 1        - PUT has exited on its own 
--                  -- 2        - last input was given to the PUT and killed after timeout
--                  -- 4        - PUT has been terminated
--                  -- 8        - PUT has been terminated after reaching the timeout
--                  -- 16       - PUT has been terminated after a fragment timeout
--                  -- 32       - PUT has been terminated due to excessive memory consumption
--                  -- 1024     - PUT couldn't be started
--   string         Input_GetCmdArgs(InputPtr)                          - returns the cmd args the PUT was started with
--   string         Input_GetOutput(InputPtr)                           - returns the PUT's output on stdout and stderr
--   int            Input_GetReactionTimeLength(InputPtr)               - returns the length of the reaction time list (only available in fragment mode)
--   nanoseconds    Input_GetReactionTimeFirst(InputPtr)                - returns the first reactiontime
--   nanoseconds    Input_GetReactionTimeNext(InputPtr)                 - returns the next reactiontime
--   void           Input_SetPrimaryScore(InputPtr, double)             - sets the primary score for the input
--   void           Input_SetSecondaryScore(InputPtr, double)           - sets the secondary score for the input
--   void           Input_EnablePrimaryScoreIndividual(InputPtr)        - enables individual primary scores
--   void           Input_EnableSecondaryScoreIndividual(InputPtr)      - enables individual secondary scores
--   void           Input_AddPrimaryScoreIndividual(InputPtr, double)   - adds an individual primary score
--   void           Input_AddSecondaryScoreIndividual(InputPtr, double) - adds an individual secondary score
--   void           Input_ClearScores(InputPtr)                         - clears all set scores
--   void           Input_ClearTrim(InputPtr)                           - clears trim status of input
-- Return Value
--      -- 0    - unfinished (input is unfinished and can be extended)
--      -- 1    - passing
--      -- 2    - failing
--      -- 4    - undefined (unknown)
--      -- 64   - input is a prefix of an already known input
--      -- 128  - repeat test

local exitcode = ...

print(exitcode)

output = io.read("*a")

lines = {}
i = 1
for str in string.gmatch(output, "([^\n]*)\n") do
    lines[i] = str
    i = i + 1
end

positions = {}
x = 1
y = true -- first score found
current = ""
open = false
for c = 1,#lines do
    if lines[c] ~= nil and lines[c] ~= "\r" and lines[c] ~= '' then -- \r is for windows 
        if open == false then
            if (lines[c]:sub(1,1) == "+") then -- + is the first character in the first line of the current position in the output of the mace
                open = true
                current = ""
            end
        else
            current = current .. lines[c]
        end
    else
        if open == true then
            open = false

            found = false
            for k = 1,#positions do
                if (positions[k] == current) then
                    found = true
                    break
                end
            end
            if found == false then
                positions[x] = current
                x = x + 1
            end
            if (y == true) then
                y = false
            else
            end
        end
    end
end

if (tonumber(exitcode) == 0) then
    print("result1: " .. (#positions+1))
else
    print("result2: " .. #positions)
end
