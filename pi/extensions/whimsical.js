import { visibleWidth, wrapTextWithAnsi } from "@earendil-works/pi-tui";

const thinkingMessages = [
  // One word
  "Conglobating...",
  "Yarnspinning...",
  "Yarnstorming...",
  "Wishfulfilling...",
  "Winterproofing...",
  "Vernacularizing...",
  "Overcaffeinating...",
  "Algorithmicizing...",
  "Anthropomorphizing...",
  "Chromatofocusing...",
  "Transcendentalizing...",
  "Contradistinguishing...",
  "Crosscontaminating...",
  "Absconding...",
  "Absquatulating...",
  "Amalgamating...",
  "Ambling...",
  "Angling...",
  "Bamboozling...",
  "Battering...",
  "Bedazzling...",
  "Bedoodling...",
  "Befuddling...",
  "Beguiling...",
  "Bewitching...",
  "Biffing...",
  "Blathering...",
  "Blithering...",
  "Blorping...",
  "Boffing...",
  "Bonking...",
  "Bouldering...",
  "Brewing...",
  "Brimming...",
  "Bubbling...",
  "Bumbling...",
  "Bungling...",
  "Burbling...",
  "Bustling...",
  "Canoodling...",
  "Channelling...",
  "Chattering...",
  "Clamoring...",
  "Clanking...",
  "Clattering...",
  "Clomping...",
  "Clunking...",
  "Cogitating...",
  "Combobulating...",
  "Concocting...",
  "Confabulating...",
  "Contemplating...",
  "Coruscating...",
  "Crumbling...",
  "Dangling...",
  "Dawdling...",
  "Daydreaming...",
  "Defenestrating...",
  "Dillydallying...",
  "Discombobulating...",
  "Dithering...",
  "Doing...",
  "Doodling...",
  "Drumming...",
  "Effervescing...",
  "Enamoring...",
  "Enchanting...",
  "Extemporizing...",
  "Faffing...",
  "Feathering...",
  "Fermenting...",
  "Fiddling...",
  "Figgling...",
  "Finagling...",
  "Fizzing...",
  "Flattering...",
  "Flibbertigibbeting...",
  "Flittering...",
  "Flonking...",
  "Flummoxing...",
  "Flumping...",
  "Foraging...",
  "Fossicking...",
  "Freestyling...",
  "Frittering...",
  "Frolicking...",
  "Fumbling...",
  "Futzing...",
  "Galumphing...",
  "Gamboling...",
  "Gestating...",
  "Gibbering...",
  "Glamoring...",
  "Glimmering...",
  "Glittering...",
  "Glurping...",
  "Gobsmacking...",
  "Gonkulating...",
  "Grooving...",
  "Grumbling...",
  "Gurgling...",
  "Hammering...",
  "Hatching...",
  "Heathering...",
  "Higgling...",
  "Honking...",
  "Humbling...",
  "Humming...",
  "Hustling...",
  "Imagining...",
  "Improvising...",
  "Jabbering...",
  "Jamming...",
  "Jangling...",
  "Jiggling...",
  "Jingling...",
  "Jittering...",
  "Jostling...",
  "Jumbling...",
  "Jungling...",
  "Kerfuffling...",
  "Kerplunking...",
  "Kibbitzing...",
  "Kingling...",
  "Leathering...",
  "Lollygagging...",
  "Luminescing...",
  "Lurking...",
  "Malingering...",
  "Mangling...",
  "Marinating...",
  "Mattering...",
  "Meandering...",
  "Mesmerizing...",
  "Miffing...",
  "Mingling...",
  "Moldering...",
  "Moseying...",
  "Mulling...",
  "Mumbling...",
  "Musing...",
  "Mystifying...",
  "Nattering...",
  "Niggling...",
  "Noodging...",
  "Noodling...",
  "Numbing...",
  "Oscillating...",
  "Pattering...",
  "Perambulating...",
  "Percolating...",
  "Perplexing...",
  "Persnicketing...",
  "Phosphorescing...",
  "Piggling...",
  "Pirouetting...",
  "Pizzazzing...",
  "Plonking...",
  "Plumbing...",
  "Pondering...",
  "Pontificating...",
  "Pottering...",
  "Primming...",
  "Procrastinating...",
  "Pulsating...",
  "Puttering...",
  "Rattling...",
  "Razzmatazzing...",
  "Recombobulating...",
  "Ricocheting...",
  "Ringling...",
  "Rumbling...",
  "Ruminating...",
  "Rummaging...",
  "Rustling...",
  "Sashaying...",
  "Sauntering...",
  "Scampering...",
  "Scattering...",
  "Scavenging...",
  "Schlepping...",
  "Schlurping...",
  "Schmalzing...",
  "Schmoozing...",
  "Scintillating...",
  "Scribbling...",
  "Shattering...",
  "Shimmering...",
  "Shimmying...",
  "Shouldering...",
  "Simmering...",
  "Singling...",
  "Skedaddling...",
  "Skimming...",
  "Skittering...",
  "Skulking...",
  "Sleuthing...",
  "Slithering...",
  "Smoldering...",
  "Snazzifying...",
  "Snorkeling...",
  "Snurfling...",
  "Somersaulting...",
  "Sparkling...",
  "Spelunking...",
  "Splattering...",
  "Splooshing...",
  "Splorfing...",
  "Splunging...",
  "Squelching...",
  "Squiggling...",
  "Squonking...",
  "Stammering...",
  "Steeping...",
  "Struggling...",
  "Strumming...",
  "Stumbling...",
  "Sublimating...",
  "Swashbuckling...",
  "Swooshing...",
  "Synthesizing...",
  "Tangling...",
  "Tattering...",
  "Teetering...",
  "Tethering...",
  "Thrumming...",
  "Thumbing...",
  "Thunking...",
  "Thwacking...",
  "Tingling...",
  "Tinkering...",
  "Tittering...",
  "Tottering...",
  "Traipsing...",
  "Transmuting...",
  "Trimming...",
  "Tumbling...",
  "Twittering...",
  "Unbefuddling...",
  "Undulating...",
  "Vamoosing...",
  "Vibing...",
  "Wangling...",
  "Weathering...",
  "Whimming...",
  "Whirring...",
  "Whomping...",
  "Whooshing...",
  "Wibbling...",
  "Wiggling...",
  "Withering...",
  "Wobbling...",
  "Woolgathering...",
  "Wrangling...",
  "Wriggling...",
  "Yammering...",
  "Yodeling...",
  "Zigzagging...",
  "Zonking...",
  "Zorping...",

  // Phrase
  "Absolving the abstractions...",
  "Abyss staring back...",
  "Achieving enlightenment...",
  "Adding a dash of elegance...",
  "Adjusting the cosmic frequency...",
  "Aerating the arrays...",
  "Aging the algorithms gracefully...",
  "Aligning the chakras...",
  "Anointing the algorithms...",
  "Appeasing the garbage collector...",
  "Archeologically analyzing the architecture...",
  "Ascending to a higher plane...",
  "Asking the electrons...",
  "Asking the hamsters to run faster...",
  "Backpacking through the binaries...",
  "Baking at 350 kilobytes...",
  "Baptizing the binary...",
  "Barbecuing the bugs...",
  "Bargaining with fate...",
  "Believing really hard...",
  "Bewitching the boolean logic...",
  "Blanching the branches...",
  "Blessing the build process...",
  "Bottling the buffers...",
  "Braising the breakpoints...",
  "Bribing the byte fairies...",
  "Bribing the compiler...",
  "Bribing the runtime...",
  "Bungee jumping into the backend...",
  "Buttering up the firewall...",
  "Caffeinating...",
  "Calibrating the flux capacitor...",
  "Camping in the codebase...",
  "Canning the constants...",
  "Caramelizing the callbacks...",
  "Channeling the ancient developers...",
  "Charging the crystals...",
  "Charming the curly braces...",
  "Checking under the hood...",
  "Cherry-picking the commits...",
  "Cleansing the closures...",
  "Communing with the machine spirit...",
  "Consecrating the callbacks...",
  "Consulting ancient scrolls...",
  "Consulting the oracle...",
  "Consulting the rubber duck...",
  "Consulting the void...",
  "Convincing the pixels to cooperate...",
  "Cracking the conundrums...",
  "Cross-examining the debugger...",
  "Curing the code smells...",
  "Cursing the cache misses...",
  "Dancing with dependencies...",
  "Decanting the data structures...",
  "Decoding the mysteries...",
  "Decorating the deployment...",
  "Discovering hidden semicolons...",
  "Divining the answer...",
  "Doing the deployment dance...",
  "Dowsing for bugs...",
  "Drizzling debug sauce...",
  "Dusting off the neurons...",
  "Emancipating the enums...",
  "Enchanting the error handlers...",
  "Excavating ancient APIs...",
  "Existentially questioning...",
  "Exorcising the exceptions...",
  "Experiencing a flash of insight...",
  "Feeding the machine...",
  "Flambéing the failures...",
  "Flattering the floating points...",
  "Flirting with the database...",
  "Folding in the features...",
  "Forgiving the for loops...",
  "Fossil hunting in the functions...",
  "Freeing the functions...",
  "Frosting the functions...",
  "Garnishing the getters...",
  "Giving the code a pep talk...",
  "Glamping in the globals...",
  "Glazing the graphics...",
  "Greasing the gears...",
  "Grilling the glitches...",
  "Hang gliding through the heap...",
  "Harvesting the outputs...",
  "Having a little think...",
  "Having a moment of clarity...",
  "Having words with the cache...",
  "Herding cats in memory...",
  "Herding pointers...",
  "Hexing the hexadecimals...",
  "Hiking through the headers...",
  "Hoping for the best...",
  "Hypnotizing the hash tables...",
  "Icing the interfaces...",
  "Interrogating the stack trace...",
  "Invoking elder functions...",
  "Jarring the JavaScript...",
  "Jinxing the JSON parsers...",
  "Kicking the tires...",
  "Kneading the namespaces...",
  "Letting the dough rise...",
  "Letting the logic breathe...",
  "Liberating the lambdas...",
  "Lobbying the scheduler...",
  "Making offerings to the CI...",
  "Manifesting solutions...",
  "Massaging the heap...",
  "Maturing the methods...",
  "Mesmerizing the memory banks...",
  "Mountain climbing the modules...",
  "Negotiating with cosmic rays...",
  "Negotiating with deadlines...",
  "Negotiating with entropy...",
  "Nurturing the algorithm...",
  "Oiling the cogs...",
  "Parasailing past the parameters...",
  "Pardoning the pointers...",
  "Performing arcane rituals...",
  "Petitioning the kernel...",
  "Pickling the packages...",
  "Picnicking with the processes...",
  "Planting computational seeds...",
  "Plating the output nicely...",
  "Pleading with the logs...",
  "Poaching the pointers...",
  "Polishing the algorithms...",
  "Politely asking the CPU...",
  "Praying to the uptime gods...",
  "Presenting with pizzazz...",
  "Preserving the protocols...",
  "Proofing the promises...",
  "Pruning the decision branches...",
  "Purifying the parameters...",
  "Raising the exceptions...",
  "Reading tea leaves...",
  "Reading the room...",
  "Rearranging deck chairs...",
  "Reasoning with the memory...",
  "Receiving transmissions from the cloud...",
  "Redeeming the recursion...",
  "Releasing the references...",
  "Reticulating splines...",
  "Reversing the polarity...",
  "Ripening the results...",
  "Roasting the race conditions...",
  "Rolling out the runtime...",
  "Sacrificing to the demo gods...",
  "Sanctifying the source code...",
  "Sautéing the syntax errors...",
  "Schmoozing the network...",
  "Scrying the codebase...",
  "Scuba diving in the data...",
  "Searing the segments...",
  "Seasoning the solutions...",
  "Seducing the semicolons...",
  "Serenading the syntax...",
  "Shaking loose the cobwebs...",
  "Shaking the magic 8-ball...",
  "Shuffling bits around...",
  "Skateboarding down the stack trace...",
  "Skydiving through the source...",
  "Smoking the subroutines...",
  "Snorkeling through the streams...",
  "Snowboarding through the schemas...",
  "Solving the riddles of RAM...",
  "Spellbinding the stack frames...",
  "Spelunking through the stack...",
  "Spicing up the specs...",
  "Spinning up the squirrels...",
  "Sprinkling some magic dust...",
  "Squinting at the problem...",
  "Staring into the abyss...",
  "Stoking the furnace...",
  "Stroking chin thoughtfully...",
  "Summoning semicolons...",
  "Surfing the syntax waves...",
  "Sweet-talking the API...",
  "Taking the bytes out for lunch...",
  "Taming wild pointers...",
  "Tangoing with type errors...",
  "Teaching electrons new tricks...",
  "Teaching old code new tricks...",
  "Tickling the stack...",
  "Topping with tests...",
  "Transcending mere computation...",
  "Trekking through the trees...",
  "Tuning the vibrations...",
  "Unbinding the variables...",
  "Unearthing buried bugs...",
  "Unlocking the secrets of silicon...",
  "Unraveling the regex...",
  "Untangling spaghetti...",
  "Untying the type knots...",
  "Waiting for a sign...",
  "Waltzing through the codebase...",
  "Warming up the hamsters...",
  "Watering the logic tree...",
  "Waxing philosophical...",
  "Whisking the widgets...",
  "Whispering passwords to the void...",
  "Whispering sweet nothings to the compiler...",
  "Whispering to the bits...",
  "Willing it into existence...",
  "Winding up the clockwork...",
  "Wining and dining the servers...",
  "Wooing the while loops...",
];

const startupMessages = [
  "99 reported bugs in the code, 99 reported bugs. Take one down, patch it around, 100 reported bugs in the code.",
  "A watched build never boils.",
  "All abstractions leak. Bring a towel.",
  "All code is guilty until proven innocent by the tests.",
  "Another day, another diff.",
  "If a tree falls in /dev/null, does it make a sound?",
  "In theory, theory and practice are the same. In practice, they're not.",
  "Keep your friends close, and your dependencies closer.",
  "One small prompt for a man, one giant merge conflict for the team.",
  "Somewhere, a semicolon decides the fate of nations.",
  "The best code is the code you didn't have to write.",
  "The bug you cannot find is the one teaching you the most.",
  "The code you wrote yesterday is the legacy you fight today.",
  "The terminal is dark and full of terrors. It's dangerous to go alone.",

  // Quotes
  // Credit to https://dev.to/mcsee/software-engineering-great-quotes-26ci for collecting most of these
  "20 years from now, the only people who will remember that you worked late are your kids", // Reddit
  "90% of the functionality delivered now is better than 100% delivered never.", // Brian W. Kernighan
  "A complex system that works is invariably found to have evolved from a simple system that worked.", // John Gall
  "A distributed system is one in which the failure of a computer you didn't even know existed can render your own computer unusable.", // Leslie Lamport
  "A human organization is just as much an information system as any computer system. It is almost certainly more complex, but the same fundamental ideas apply. Things that are fundamentally difficult, like concurrency and coupling, are difficult in the real world of people, too.", // Dave Farley
  "Adding functionality is not just a matter of adding code.", // Wietse Venema
  "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.", // John Woods
  "Any sufficiently advanced bug is indistinguishable from a feature.", // Bruce Brown
  "As a program is evolved its complexity increases unless work is done to maintain or reduce it.", // Lehman’s law of Increasing Complexity
  "Be curious. Read widely. Try new things. I think a lot of what people call intelligence boils down to curiosity.", // Aaron Swartz
  "Bugs lurk in corners and congregate at boundaries.", // Boris Beizer
  "Code is like humor. When you have to explain it, it’s bad.", // Cory House
  "Code without tests is broken by design.", // Jacob Kaplan-Moss
  "Comments often are used as a deodorant", // Martin Fowler
  "Compatibility means deliberately repeating other people's mistakes.", // David Wheeler
  "Deleted code is debugged code.", // Jeff Sickel
  "Discovery consists of seeing what everyone else has seen and thinking what no one else has thought.", // Albert Szent-Gyorgi
  "Don't Gather Requirements, Dig for Them", // Andrew Hunt
  "Don’t comment bad code — rewrite it.", // Brian Kernighan
  "Einstein repeatedly argued that there must be simplified explanations of nature, because God is not capricious or arbitrary. No such faith comforts the software engineer.", // Fred Brooks
  "Feedback is essential to our ability to learn. Without fast, effective feedback, we are guessing. Both the speed and the quality of feedback matter. If feedback is too late, it is useless. If it is misleading or wrong, the decisions that we make will be wrong, too", // Dave Farley
  "Feedback is the breakfast of champions.", // Ken Blanchard
  "First do it, then do it right, then do it better.", // Addy Osmani
  "First think about what the ultimate would be. Then take a step away from that, and another, until you get something you can build.", // Matt Reedy
  "Fools ignore complexity. Pragmatists suffer it. Some can avoid it. Geniuses remove it.", // Alan Perlis
  "Good programmers don't just write programs. They build a working vocabulary.", // Guy Steele
  "Good software, like wine, takes time.", // Joel Spolsky
  "Great software today is often preferable to perfect software tomorrow.", // Andrew Hunt
  "Haven't I taught you anything? What have I always told you? Never trust anything that can think for itself if you can't see where it keeps its brain?", // Mr. Weasley
  "He who fights with monsters might take care lest he thereby become a monster. And if you gaze for long into an abyss, the abyss gazes also into you.", // Nietzsche
  "If debugging is the process of removing software bugs, then programming must be the process of putting them in.", // Edsger Dijkstra
  "If we wish to count lines of code, we should not regard them as 'lines produced' but as 'lines spent'.", // Edsger Dijkstra
  "If you can improve just one thing in your software development, make it getting faster feedback.", // Dave Farley
  "If you get tired of writing for loops, take a break and continue later.", // David Walker
  "If you have too many special cases, you are doing it wrong.", // Craig Zerouni
  "If you say “I told you so”, you are the one who has failed. Because you knew, but did not manage to stop the train wreck.", // Robert Martin
  "It is easier to optimize correct code than to correct optimized code.", // Bill Harlan
  "It takes 20 years to build a reputation and a few minutes of cyber-incident to ruin it.", // Stephane Nappo
  "Make it work, then make it right.", // Robert Martin
  "One broken window, left unrepaired for any substantial length of time, instills in the inhabitants of the building a sense of abandonment—a sense that the powers that be don't care about the building. So another window gets broken. People start littering. Graffiti appears. Serious structural damage begins. In a relatively short span of time, the building becomes damaged beyond the owner's desire to fix it, and the sense of abandonment becomes reality.", // Andrew Hunt
  "One man's crappy software is another man's full time job.", // Jessica Gaston
  "One of the main causes of the fall of the Roman Empire was that, lacking zero, they had no way to indicate successful termination of their C programs.", // Robert Firth
  "Optimism is an occupational hazard of programming: feedback is the treatment.", // Kent Beck
  "Pair programmers: Keep each other on task. Brainstorm refinements to the system. Clarify ideas. Take initiative when their partner is stuck, thus lowering frustration. Hold each other accountable to the team's practices.", // Kent Beck
  "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.", // Antoine de Saint Exupery
  "Premature optimization is the root of all evil", // Donald Knuth
  "Quality is never an accident; it is always the result of intelligent effort.", // John Ruskin
  "Rarely is anyone thanked for the work they did to prevent the disaster that didn't happen", // Mikko Hypponen
  "Remember, code is your house, and you have to live in it.", // Michael C. Feathers
  "Simplicity before generality, use before reuse.", // Kevlin Henney
  "Simplicity does not precede complexity, but follows it", // Alan Perlis
  "Simplicity is a great virtue but it requires hard work to achieve it and education to appreciate it. And to make matters worse: complexity sells better.", // Edsger Dijkstra
  "Simplicity is prerequisite for reliability.", // Edsger Dijkstra
  "Software as an asset isn't stable over time; it needs to be maintained.", // Brian Behlendorf
  "Some people, when confronted with a problem, think “I know, I’ll use regular expressions.” Now they have two problems.", // Jamie Zawinski
  "Successful software always gets changed.", // Fred Brooks
  "Teams are immutable. Every time someone leaves, or joins, you have a new team, not a changed team.", // Richard Dalton
  "Tests are the Programmer’s stone, transmuting fear into boredom.", // Kent Beck
  "The art of debugging is figuring out what you really told your program to do rather than what you thought you told it to do.", // Andrew Singer
  "The best reaction to “this is confusing, where are the docs” is to rewrite the feature to make it less confusing, not write more docs.", // Jeff Atwood
  "The best way to start fixing a bug is to make it reproducible. After all, if you can’t reproduce it, how will you know if it is ever fixed?", // Andrew Hunt
  "The computer programmer is a creator of universes for which he alone is the lawgiver. No playwright, no stage director, no emperor, however powerful, has exercised such absolute authority to arrange a stage or field of battle.", // Joseph Weizenbaum
  "The earlier you catch defects, the cheaper they are to fix.", // Dave Farley
  "The first step of any project is to grossly underestimate its complexity and difficulty.", // Nicoll Hunt
  "The greatest obstacle to discovery is not ignorance, but the illusion of knowledge.", // Daniel Boorstin
  "The key to efficient development is to make interesting new mistakes.", // Tom Love
  "The most dangerous kind of waste is the waste we do not recognize.", // Shigeo Shingo
  "The most important property of a program is whether it accomplishes the intention of its user.", // C.A.R Hoare
  "The only way to go fast, is to go well.", // Robert Martin
  "The problem is, in software design, often the consequences of your decisions don't become apparent for years.", // Kent Beck
  "The problem with quick and dirty, is that the dirty remains long after the quick has been forgotten", // Steve C. McConnell
  "The purpose of software engineering is to control complexity, not to create it.", // Pamela Zave
  "There are two ways to write code: write code so simple there are obviously no bugs in it, or write code so complex that there are no obvious bugs in it.", // Tony Hoare
  "There is nothing so useless as doing efficiently that which should not be done at all.", // Peter Drucker
  "There is so much waste in software development. The waste is rooted more in what we believe and feel than in what we do. Becoming aware of and addressing those beliefs and feelings takes time and experience", // Kent Beck
  "There’s nothing more permanent than a temporary hack.", // Kyle Simpson
  "Watch the little things; a small leak will sink a great ship.", // Benjamin Franklin
  "Why do most developers fear to make continuous changes to their code? They are afraid they’ll break it! Why are they afraid they’ll break it? Because they don’t have tests.", // Robert Martin
  "With good program architecture debugging is a breeze, because bugs will be where they should be.", // David May
  "You do not really understand something unless you can explain it to your grandmother.", // Albert Einstein
  "You either die a software engineer or you live long enough to see yourself become the project manager.", // Reddit
  "You haven't mastered a tool until you understand when it should not be used.", // Kelsey Hightower

  // Agile Manifesto
  "Individuals and interactions over processes and tools",
  "Working software over comprehensive documentation",
  "Customer collaboration over contract negotiation",
  "Responding to change over following a plan",
  "Our highest priority is to satisfy the customer through early and continuous delivery of valuable software.",
  "Welcome changing requirements, even late in development. Agile processes harness change for the customer's competitive advantage.",
  "Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale.",
  "Business people and developers must work together daily throughout the project.",
  "Build projects around motivated individuals. Give them the environment and support they need, and trust them to get the job done.",
  "The most efficient and effective method of conveying information to and within a development team is face-to-face conversation.",
  "Working software is the primary measure of progress.",
  "Agile processes promote sustainable development. The sponsors, developers, and users should be able to maintain a constant pace indefinitely.",
  "Continuous attention to technical excellence and good design enhances agility.",
  "Simplicity--the art of maximizing the amount of work not done--is essential.",
  "The best architectures, requirements, and designs emerge from self-organizing teams.",
  "At regular intervals, the team reflects on how to become more effective, then tunes and adjusts its behavior accordingly.",
];

function pick(list) {
  return list[Math.floor(Math.random() * list.length)];
}

// Mute the "Update Available"
process.env.PI_SKIP_VERSION_CHECK = "1";

function renderBanner(message, width, theme) {
  const rule = theme.fg("warning", "─".repeat(width));
  const centered = wrapTextWithAnsi(message, Math.max(1, width - 8)).map((line) => {
    const pad = " ".repeat(Math.max(0, Math.floor((width - visibleWidth(line)) / 2)));
    return pad + theme.bold(line);
  });
  return ["", rule, "", ...centered, "", rule, ""];
}

export default function (pi) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    const message = pick(startupMessages);
    ctx.ui.setHeader((_tui, theme) => ({
      render: (width) => renderBanner(message, width, theme),
      invalidate() {},
    }));
  });

  pi.on("turn_start", async (_event, ctx) => {
    ctx.ui.setWorkingMessage(pick(thinkingMessages));
  });

  pi.on("turn_end", async (_event, ctx) => {
    ctx.ui.setWorkingMessage(); // Reset for next time
  });
}
