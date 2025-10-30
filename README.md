# connect_four
A command line game of connect four as part of The Odin Project

METHODS
board.valid_column?
    This method is not easily dynamic to changing the size of the board. The valid columns are hard coded. Maybe I could use an instance variable of board that populates and array of valid column options once the board object is initialized.

board.available_column?
    Should there be an error raised in the case a non-viable column gets entered into the method? The structure of my program uses a different method to make sure the column is an actual column, but that could change if the method gets used and someone forgets the method is assuming the argument will be a column option.

TESTS
Board
    #approved_choice?
        This test might be uneccessary, as this method is a script (I think) method, and not a looping script
        I am currently entering a value into this test but it isn't being read in any way that matters. This might be because it is not a worthwhile test (i.e. it is a script) or maybe I am testing the wrong thing. Maybe I should be testing that this script calls those methods. but I probably shouldn't be testing it at all.