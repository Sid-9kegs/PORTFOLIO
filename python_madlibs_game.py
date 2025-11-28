
################################### FUN MADLIBS GAME ##############################
## Making a fun Madlibs game using python.

print()
print('HAVE FUN!!! PLAYING MADLIBS.')
print()
print('**Pro Tip:** The sillier and more random the words, the funnier the story becomes!')
print()
print()
## Establishing Rules
print('''RULES: \n
 1.	Ask you friend to input the words.\n
 2. Ask for a word that matches each part of speech (e.g., "Give me an adjective for blank 1")\n
 3. Write the words in the blanks as you go\n
 4. Read the completed story aloud for hilarious results!''')
print()
## Asking the User Input and Specifying the part of speech each input should be 

adj1= input('Please Enter a Adjective(silly/weird): ')

adj2= input('Please Enter a Adjective(ridiculous): ')

num1= input ('Please Enter a Number(between 1-12): ')

nplace = input('Please Enter a Proper Noun(made-up place name): ')

noun1 = input('Please Enter a Noun(imagination, dreams, etc.): ')

nperson =input ('Please Enter a Noun(person/creature): ')

print()
print()

## Using a f string to enter user input values into the madlib

madlib = (f'''Last summer, I decided to take the most {adj1} vacation of my life.
I packed my suitcase with {adj2} items and headed to the airport at {num1} AM looking absolutely ridiculous.\n

At check-in, the agent took one look at me and asked, 
"Where exactly are you going?" I replied confidently, "I'm heading to {nplace}!" She stared at me blankly and said,
"That's not a real place, is it?" I assured her it definitely was, at least in my {noun1}.\n

On the plane, I sat next to a {nperson} who immediately fell asleep and started snoring so loudly that the flight attendant asked if we'd brought livestock onboard. 
I considered asking for a refund right then and there.
 ''')
## Giving the Hilarious output back to the User 
print(madlib)




