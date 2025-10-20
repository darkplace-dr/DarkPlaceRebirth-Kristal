local book, super = Class(ReadableBook)

function book:init()
    super.init(self)

    self.id     = "captain_journal"
    self.title  = "Captain's Log"
    self.author = "Captain Harold Darkbeard"
    self.volume = 26

    self.show_details = false -- Show the title and author of the book or note in the first page.
    
    self.pages = {
        [1] = [[
					   [s:3][b]Entry 1
		[b]Just before setting off on an adventure to the light crystals, a father approached me with her daughter. She was not in very good condition, and the father explained to me that his daughter, named Marcy, was unable to enter the light world due to her condition.
		I took it upon myself to assist the father with his problem. The cure to the condition his daughter has is where we're going, after all.
		]],
    }
    --Game.world:openMenu(bookMenu(booksLib:createBook("captain_journal"))) to open book
end

return book