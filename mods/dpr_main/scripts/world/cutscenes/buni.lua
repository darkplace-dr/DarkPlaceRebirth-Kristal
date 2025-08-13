return {
    d = function(cutscene, event)
        if Game:getFlag("WONQUIZ") then
            cutscene:text("* I have nothing left to ask of you.")
            cutscene:text("* You are the master of Starrune trivia.")
        else
            cutscene:text("* Welcome! I am the STARRUNE POPSTAR EXPERT!")
            cutscene:text("* Can you answer my seven trvia questions correctly?")
            local opinion = cutscene:choicer({"I can!", "I can't..."})
            if opinion == 1 then
                Music:stop()
                cutscene:text("* WRONG!")
                cutscene:text("* Heh, just a small joke.")
                Game.world.music:play("BABASPACE")
                cutscene:text("* The MIDI for this song has been made by Theopold The Gamer.")
                cutscene:text("* All questions assume the answers are for Starrune: Popstar.")
                Game:setFlag("QUIZWRONG", false)
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 1:")
                    cutscene:text("* Who is the third main party member besides Kris and Susie in Starrune?")
                    local text = cutscene:getUserText(10)
                    if text == "NOELLE" or text == "NOELLEH" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 2:")
                    cutscene:text("* Who is the first boss of the Vegtable Valley?")
                    local text = cutscene:getUserText(10)
                    if text == "BUGZZY" or text == "HITBOX" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 3:")
                    cutscene:text("* What is Noelle's 0 TP Heal spell called?")
                    local text = cutscene:getUserText(10)
                    if text == "FIRSTAID" or text == "PERSIST" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 4:")
                    cutscene:text("* What color is the new soul mode made for Starrune?")
                    local text = cutscene:getUserText(10)
                    if text == "ORANGE" or text == "DARKBLUE" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 5:")
                    cutscene:text("* Which character appears in both STARRUNE and MICE MIRACLE?")
                    local text = cutscene:getUserText(10)
                    if text == "LIBITINA" or text == "KYOUKO" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 6:")
                    cutscene:text("* What is the name of the character that set up the Jukebox?")
                    local text = cutscene:getUserText(10)
                    if text == "BIANKA" or text == "MONIKA" then
                        cutscene:text("* Correct!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                if not Game:getFlag("QUIZWRONG") then
                    cutscene:text("* Question 7:")
                    cutscene:text("* How high is the attack stat of Foley?")
                    local text = cutscene:getUserText(10)
                    if text == "15" or text == "FIFTEEN" then
                        cutscene:text("* Correct!")
                        Game.total_bp = Game.total_bp + 1
                        Game:setFlag("WONQUIZ", true)
                        cutscene:text("* Here, take this badge point.")
                        cutscene:text("* You earned it, buddy.")
                        cutscene:text("* In case you don't have badges yet, try the puzzle below me!")
                    else
                        Game:setFlag("QUIZWRONG", true)
                        cutscene:text("* Wrong!")
                    end
                end
                Game.world.music:play("TRITRALAND")
            end
        end
    end
}