---
title: "My Nand2Tetris Journey: Lessons and Reflections"
date: 2024-10-19T00:00:00-06:00
draft: false
---

Earlier this year, I decided to take on the well-known [Nand2Tetris](https://www.nand2tetris.org/) course, a project that regularly pops up on Hacker News. My goal? To understand how computers work at the lowest level of abstraction I was willing to explore. This course covers everything from the basic NAND gate all the way to building a fully functioning computer, and it promised to be both an exciting and challenging ride. Here's my experience and the lessons I learned along the way. 

[Relevant XKCD comic](https://xkcd.com/435/).

You can find my open-source solutions to all the projects [here](https://github.com/badstreff/nand2tetris).

---

## Projects 0-5: Building the Hack Computer

The first few projects (0-4) were full of "aha" moments. Rewatching the videos and revisiting the material helped the pieces fall into place. However, when I hit Project 5, it felt like one of those tests where you're completely lost despite attending every lecture. In my opinion, this is the first real challenge of the course. While the implementation is elegant and seemingly simple at first glance, understanding its inner workings takes real effort.

---

## Project 6: Assembler

Building the assembler was a fun and relatively straightforward task. I didn't stick to the book's recommended approach and instead implemented it my way, which I found more intuitive. I even wrote some basic unit tests, as the problem space was clear and manageable. This part of the course felt like a breath of fresh air after Project 5.

---

## Projects 7-8: Translator

Welcome to the second half of the course! The instructors give a fair warning at the start of this section: if you don't have programming experience, you're in for a tough time. Still, I'd recommend watching the videos even if you're struggling with the exercises—the material is well-presented and worth understanding.

Unfortunately, my translator did not follow the recommended approach, which cost me a lot of extra time. There’s a lot of room for optimization here, and if you check out the class forums, you’ll find people discussing optimizations they've made. But as for me? Ain't nobody got time for that.

---

## Projects 10-11: Compiler

Having learned my lesson from the previous sections, I decided to stick closely to the book’s approach when writing the compiler. The process was more efficient this way. 

The compiler features a helpful `_eat` method (not required but highly recommended) that validates if the expected token is being consumed. Other than that, it’s a straightforward implementation of the course’s instructions. That said, there are several things in my code that are far from idiomatic Python, but I was more focused on understanding the material than writing clean Python code.

---

## Project 12: OS

This was the part of the course I had been most excited about—and it turned out to be the biggest letdown. Rather than building an operating system, it felt more like implementing a Jack standard library. 

I ended up skipping the Screen, Output, and Keyboard classes from Project 12 and sourced them from [here](https://github.com/havivha/Nand2Tetris). The rest of the project I completed on my own. My Memory module passes the test, though it could benefit from a defrag implementation. It's actually a pretty clever solution, and I haven't seen another quite like it.

In the end, I found myself wishing for more. I had hoped to implement an actual operating system with features like a basic filesystem, process scheduling, memory management, and more. Instead, it felt like just enough to work with RAM, with the rest functioning more as a standard library for the Hack language.

---

## Final Thoughts

Would I recommend this course? It depends on what you’re looking for. For me, it was incredibly valuable, and I plan to take on more advanced OS classes in the future. If any of the following apply to you, I think you'll enjoy Nand2Tetris:

1. You want to understand how computers work at a low level.
2. You have an interest in compilers but lack prior experience.
3. You enjoyed computer architecture in college and are feeling nostalgic.
4. You're planning to take more advanced OS or compiler courses in the future.

However, if you're looking to dive deep into these topics, this might not be the course for you. The instructors do an amazing job of giving a whirlwind tour of computer organization, operating systems, and compilers, but since it’s designed to run in 12 weeks, the depth is limited unless you’re completely new to the material or need a refresher.
