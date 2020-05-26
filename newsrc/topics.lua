	

crude_names_front = {"Al", "Bre", "Cel", "Dan", "Ed", "Ford", "Guy", "Haus", "Ister",
	"Jim", "Kael", "Liam", "Mor", "Nast", "Oh", "Pel", "Qin", "Ray", "Sten","Tell",
	"Urst", "Val", "Wist", "Xen", "Yor", "Zum"}
crude_names_back = {"ane", "eber", "ic", "od", "ue", "af", "eg", "him", "oi",
	"aj", "ek", "ille", "om", "un", "ao", "ep", "quipp", "or", "us","at",
	"eur", "iv", "ow", "ux", "ay", "ez"
}

--Note there needs to be 27 items or you will get an array out of bounds nill!
-- moods for individual moods of villagers
villager_moods = {"very happy", "happy", "concerned", "grumbling", "angry", "enraged", "rioting"}
talk_topics_happy = { "Hello", "Im Hungry", "Will no one help me?", "I think i saw a bear!",
	"Im cold", "What is the meaning of life?", "There she goes!", "I feel so lonely",
	"Zombies are real!", "Ho hum....", "What will I do today?", "Think it will rain?",
	"Save the trees!", "Ewww...I think I stepped in something.", "Im thirsty", "Love your brother",
	"Squirrels!", "Argh! Rabbits after my patuleas again!", "Hey I think we...hmm forgot",
	"Are snails edible?", "There is an odour under my arms.", "I see things in my sleep",
	"bleh...", "Hahahaha!", "Hehehe....", "Whats this?", "Go ahead... make my day!"}
talk_topics_earthquake = { "Uh..why is everything shakeing?", "Earthquake!", "We're having an earthquake!", 
        "Aaaagh!!", "We're doomed!", "Oh no! My house!", "When will this end?", "Earthquake!!",
        "Everythings colapsing!", "What?", "Help!!!", "We are going to die!",
        "Save the babies!", "My roof!", "Take cover!", "It wont stop!",
        "Im hurt!", "Argh!!", "Hey!!! its an earthquake!",
        "This is the big one!", "I cant stand straight!", "Ea..Ear..Earthquake!",
        "Earth... do your worst!", "Mother presurve us!", "Earthquake!", "Whats this?", "Get Down!"}
talk_topics_happynight = { "The stars are beautiful!", "How about a midnight snack?", 
	"Ahh the moon.", "Know any good ghost stories?","Im cold", "What is the meaning of life?", 
	"There she goes!", "Time for bed.",	"What will tomorrow bring?", "Ho hum....", 
	"A nice warm fire...", "Did you hear howling?",	"Ah a good brew.", 
	"Finally I can rest.", "Im thirsty", "Love your wife.",	"Good thing its not cold.", 
	"Ahh, sleep.", "Sleeping under the stars would be so nice.",
	"Are snails edible?", "Ah under the starlight.", "What a romantic night.",
	"bleh...", "Hahahaha!", "Hehehe....", "Whats this?", "Go ahead... make my night!"}
talk_topics_ok = {"Keep a stiff upperlip", "Just hang in there", "We are ok.",
	"We've had our struggles", "Hard work can solve anything", "Maybe ill get my house tomorrow?", 
	"Id rather have fish than carrots", "That bear ate my food!", "Your roof is leaking", 
	"Is it me or is the water drying up?", "Psst, you stink", "Keep a stiff upperlip", 
	"Just hang in there", "We are ok.", "We've had our struggles", 
	"Hard work can solve anything", "Maybe ill get my house tomorrow?", 
	"Id rather have fish than carrots", "That bear ate my food!", "Your roof is leaking", 
	"Is it me or is the water drying up?", "Psst, your stink","That bear ate my food!", 
	"Its not bad, here just....", "Im ok, for now.", "Im soooo hongry...", 
	"We'll sleep on the ground tonight."}
talk_topics_grumbling = {"Carrots again?!?!", "How are we expected to live like this?", 
	"Oh well...", "This aint right!", "Well maybe there will be food tomorrow", 
	"Mayor? Um...", "Life is hard", "I see a train wreck coming.", 
	"This villiage is headed for disaster", "Is the mayor braindead?", 
	"If I gotta cut another tree, im gonna lose it.","Is the mayor asleep?", 
	"Corruption is to blame", "Liberals fouling up our homes!", 
	"There are no jobs!", "The taxes are too high!", "Why me? I can barely feed myself!", 
	"grrr...hmmm... oh nothing", "You all are just LAZY!", "Why, why?!?!", 
	"Im so miserable!","Hello?!?! does anyone care?", "This is all your fault!",
	"Whats the point of even trying?", "Im on strike!", "This will get worse",
	"We need more boards!"}

talk_topics_angry = {"No food again?", "Im still hungry!", "How could it get any worse?", 
	"someone otta do something!", "Im about to blow my top!", "Im starving!",
	"Its about to hit the fan!", "The end is near!", "This is all because of our sins!", 
	"How are we expected to live like this?", "The food is gone...again", 
	"This ain't right!","We are all going to die!", "You can't make me do nothing!",
	"Im going to start burning things!","You wont like me when im angry",
	"Im so mad!","Bite me, Mayor!","Its unbearable.","This is horrible!",
	"Someone's gonna pay!","Im broke, hungry and homless...yea","How about punch me in the face too!",
	"Right off a cliff...yea","I hate everyone!","Im so tired of this!",
	"Im not gonna die here!"}

talk_topics_riot = {"Rawr!", "I want blood!", "Bring out the Mayor!", 
	"Argh!", "Oh, you're gonna hear ME roar!", "Burn everything!", 
	"Burn the trees!", "Someone save me!", "its officially hit the fan!", 
	"Break their bones!", "Aiiieeee!", "Smash!", "Take their Blue ray players!", 
	"Fire, heheheh...", "We're not gonna take this anymore!", "Ill just eat YOU!", 
	"Die, Die. DIE!", "I wish I were dead!", "Flee for your lives!", 
	"For the slaying of the sword!", "Death to the breathers!", "Bring the pain!", 
	"Grrrr!", "Argh! my Knee!", "Bleed on me, and ill hurt you!", "WAAAAGH!", 
	""}
talk_topics_werewolf ={"Aaaoooo!", "Fooooooooood!", "[snarl]",  "[growl]",
	"[sniff][sniff]", "Ouuuuu!", "Arrraa!", "....",
	" ", " ", " ", "Ouuuwwww!",	" ", " ", " ", " ",	"[pant][pant]", 
		" ", 
		"I guess I just violated the treaty.",	" ", " ", " ",
	" ", "Sometimes you're a little strange, Bella. Do you know that?",
	" ", " ", " "
}
talk_topics_holyman ={"Bless you my child", "Bless you dear", "You are absolved",  
	"Dont forget to tithe", "Good shall always prevail", "This too shall pass", 
	"Do we need an inquisition?", "....",	"Cleanse your mind", "Fear no evil ", 
	"Do you have something to confess? ", "Dark Elves cannot be saved.",	
	"Repent!!!", "Give and it shall be given.", "The church needs repair ", 
	"Dont believe gossip",	"Obey the mayor.", "Work hard and give offerings ", 
	"Love your bother",	"More wine is needed for sacrement", 
	"More food is needed for sacrement", "Time heals all", "Fast today, eat tomorrow ", 
	"Beware of sin!", "Obey your parents.", "Blessed are the humble.", 
	"Blessed are the meek."
}
villager_types = { "normal", "dark elf", "bandit", "werewolf", "holyman", "dwarf"
}

tutorial_messages = { 
	--set a tutorial timer to 100, and run the timer down before displaying the next message
	--If you are required to collect something before proceeding, then wait until conditions are met
	--if tutorial_level == 1 and tutorial_timer == ??
	"Welcome to LeTownBuilder, lets get started!", --tutorial_level 0 and tutorial_timer = 0
	--set tutorial_level = 2 and tutorial_timer = 100
	--if tutorial_level == 2 and tutorial_timer == 0
	"First things first. You need to eat! collect at least 5 food by gathering in a forest tile",
	--if food >= 5 and tutorial level == 2
	--set tutorial_level = 3 and tutorial_timer = 100
	"Now you're cooking! Well not quite, but at least you wont starve.",
	--set tutorial_level = 4
	--if tutorial level == 4 and tutorial_timer = 0
	"Next, your villagers need shelter.  Cut down some trees needed for wood.",
	--if wood >= 5
	"Good Job! But you can't build a house just yet. The foundation requires stone.  Dig holes to find stone.",
	--set tutorial_level = 5
	--if tutorial_level == 5 and tutorial_timer = 0
	"Now you got some stone!",
	"Now lets build a house!",
	"Great! You need as many houses as residents, or some villagers will go homeless"
}
sheriff_topics_allday = {"Obey the Law", "Criminals shall be elimiated", 
	"Crime doesn't pay.", "Do you feel lucky, do ya punk?",
	"Pay your taxes.", "Ill keep you safe.", "I dont need a warrent.", 
	"Safty is obedience.",	"There are no werewolves.", "All clear.", 
	"Carry on, citizen.", "Pain reforms the foolish.",	"Illegal hunting shall be pusnished.", 
	"I'm hard, but im fair.", "If you see any bandits, say something.", "Support your sheriff",
	"Done mess with the law!", "I AM the law.", "Drop your weapons.",
	"Trouble follows the lazy.", "Let's see some ID", "Disobey, and your dead.",
	"I have a special little thing I do to theives", 
	"You're in violation of the noice ordinance!", "I cannot be corrupted.", 
	"Stop right there criminal scum!", "Go ahead... make my day!"}

ghost_topics_allnight = {"Vengance!", "....ooooooooh...", 
	"....uuuuh.....", "...I..lost my...slipper...",	"...am...I...?", 
	"...its cold...", "...I see dead people....", "...my...house....",	
	"...stay....", "...The mushroom...it...poison....", "Carry on, citizen.", 
	"...the pain...",	"...the rabbit...rabbies...", "...wheres my sock?.....", 
	"...its broke...the vase...", "...I'm one of you...",
	"...soon you will join me...", "...in life i was....", "...the darkness...",
	"...they said...no werewolves...", "...I was so wrong...", 
	"...and now im dead...", "...who is the mayor now?...", "...my..eyes...", 
	"...I cannot be saved...",	"...always cook your fish...", "...my..heart..."}
darkelf_topics_happy = { "Vendui", "Tlun Nug'ri", "Xxizz uns'aa", "Usstan kyor natha guy'ya",
	"Usstan tlun inthuul", "Nindolen villagers ph'kl'eril", "Gaer il gos!", "Usstan satiir ji dwalc",
	"Zombies are real!", "Ho hum....", "What will I do today?", "Think it will rain?",
	"Flamgra l'lorugen!", "Ewww...Usstan unboius wun folbol.", "Im thirsty", "Love your brother",
	"Squirrels!", "Argh! Rabbits after my patuleas again!", "Hey I think we...hmm forgot",
	"Are snails edible?", "There is an odour under my arms.", "I see things in my sleep",
	"bleh...", "Hahahaha!", "Hehehe....", "Whats this?", "Go ahead... make my day!"}
plague_list = {"bactus aquaticus", "malum carota", "cibum venena", "malificarum avernis", "rabies", "snake poison", "zombification"}
plague_symptoms = {"vomiting profusely", "coughing up blood", "difficulty breathing", 
	"Dark blotches on tongue", "heavy diarrhea", "vomiting blood", "high fever", 
	"rashes everywhere", "boils on body", "green spots on skin", "deathly pale", 
	"lesions on legs", "hair falling out"
}

plague_topics_allday = {"I..dont feel so good", "....ooooooooh...", 
	"....uuuuh.....", "Im sick!",	"Will I die?", 
	"..so cold...", "Does anyone have any medicine?", "Is there a doctor in the house?",	
	"Im turning blue!", "Make the pain stop!", "Is it bad doc?", 
	"...the pain...",	"Medic!", "Stay away! Im contagious!", 
	"I..not well...", "I'll recover.",	"I dont know if I can go on.", 
	"I will get through this.", "Im itching everywhere!",	"Excuse me.", 
	"Musta been something I ate.", "And now im sick!", "I know you think all I do is complain but...", 
	"It hurts....", "My stomach...uh...",	"...always cook your fish...", 
	"...my..heart..."
}

function display_tutorial_tips_box(tips_index)
	if game.show_tutorial == 1 then
		--draw a box and display the current message.
	end
end
