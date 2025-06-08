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
--   void           Input_GetRetries(InputPtr)                          - number of times the input was re-run
-- Return Value
--      -- 0    - unfinished (input is unfinished and can be extended)
--      -- 1    - passing
--      -- 2    - failing
--      -- 4    - undefined (unknown)
--      -- 64   - input is a prefix of an already known input
--      -- 128  - repeat test
function Oracle()
    -- check for exit reason and co
    exitreason = Input_GetExitReason(input)
    if (exitreason == 16 or exitreason == 32 or exitreason == 4) then
        return 2
    elseif (exitreason == 8) then
        if (Input_GetRetries(input) < 5) then
            return 128 -- the program cannot really timeout, which is why we will repeat it to get a proper result
        else
            return 2
        end
    elseif (exitreason == 1024) then
        if (Input_GetRetries(input) < 5) then
            return 128 -- try again
        else
            return 4
        end
    end

    output = Input_GetOutput(input)

    lines = {}
    i = 1
    for str in string.gmatch(output, "([^\n]*)\n") do
        lines[i] = str
        i = i + 1
    end

    Input_EnablePrimaryScoreIndividual(input)
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
                    Input_AddPrimaryScoreIndividual(input, #positions)
                end
            end
        end
    end
    -- we now have all the unique positions and can set that as the score
    if (exitcode == 0) then
        -- compensate for the fact that the last step only outputs "You win" if the game is won
        Input_AddPrimaryScoreIndividual(input, #positions+1)
        Input_SetPrimaryScore(input, #positions+1)
    else
        Input_SetPrimaryScore(input, #positions)
    end
    
    if (IsOSWindows() == true) then
        begin = string.find(output, "executed:")
        if (begin ~= nil) then
            sub = string.sub(output, begin + 9)
            send = string.find(sub, ":")
            if (send ~= nil) then
                sub = string.sub(sub, 0, send - 1)
                executed = tonumber(sub)
                if (executed ~= nil) then
                    Input_Trim(input, executed)
                end
            else
                --print("executed missing")
                Input_ClearScores(input)
                return 128
            end
        else
            --print("executed missing")
            Input_ClearScores(input)
            return 128
        end
    else
        begin = string.find(output, "You ") -- this is written at the end of the game and our way to detect missing output
        if (begin == nil) then
            Input_ClearScores(input)
            return 128
        end
    end

    exitcode = Input_GetExitCode(input)
    if (exitcode == 0) then
        return 1
    elseif  (exitcode == 1) then
         -- cmd args error
        print("cmd args error")
        return 4
    elseif (exitcode == 2) then
        print("command error")
         -- command error
        return 4
    elseif (exitcode == 3) then
        return 2
    elseif (exitcode == 4) then
        return 0
    end
end