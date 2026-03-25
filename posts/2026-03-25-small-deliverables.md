---

id: breaking-down-big-tasks
title: On breaking down big implementation tasks into small deliverables
date: 2026-03-16
summary: A practical method for splitting large development work into small, reviewable, and independently mergeable pieces
---

*The following article was hand written by a human.*

We've all been there. You pick up a story from the backlog, read the requirements, and realize this is going to be a big one. The temptation is to just start coding and figure it out as you go. A few days later you have an 800-line pull request touching 20 files, mixing infrastructure changes with domain logic and workflow wiring. Your reviewers stare at it, leave a few surface-level comments, and approve it because they don't have the energy to truly review the whole thing.

I’m writing this article today to go over how I personally approach software development, and how I try to break big features into small deliverables. This article is based on my personal experiences and my way of working, keep that in mind. I hope you might find something useful within the following lines.

## Start on the drawing board, not the code

It’s easier than ever to generate code nowadays. With the advent of LLMs and Agents, coding has never been easier, but has always been the easiest part in software development.

I truly believe that a good software engineer is the one who can ask the most important questions. I have a few sets of questions that guide me when designing a new piece of code. Besides those questions I also try to simplify software by seeing them merely as *functions*–with *inputs* and *outputs*. Every software can be abstracted into one simple abstract *function*, and you can break that function down into smaller functions and you can go as deep as you want or need. The deeper you go, the less abstract your description of said software will be.

Keep that in mind, software can almost always be described as *inputs* and *outputs*. I’ll not delve deep into theoretical computer science/math concepts about *set theory* or *type systems*, but I’d highly recommend you investigating those since they can help you develop a more fundamental understanding of some of the building blocks of what we call software nowadays.

### Design questions

Okay, enough abstraction, these are the questions that usually guide me when designing code. From now on I’ll use the term *feature* to describe a “piece of software”:

Why am I developing this feature?

- Think of what the feature is meant to accomplish and why you're working on it. Why are you implementing this instead of anything else? It can be because of business priorities, enjoyment, learning reasons.
- Having a strong why can help you define your "North Star"

What are the *inputs* of this feature?

- Here you can think of data models and what are the "parameters" of your feature.
- You can be as detailed as needed. From a simple struct to even defining networking diagrams.

What are the *outputs* of this feature?

- What should your feature produce?
- How can you map those outputs into a data model?
- Is this a *pure feature* or a solely side effect one? Think of *pure functions* and ask yourself: Does this feature have a result type? For example, you could be designing a GET HTTP endpoint, which can clearly have a result type.
- A side effect feature would be something like a logger or an audit table. Where the goal of the feature is not producing a result but doing something when triggered. You can map those behaviours into outputs as well.

How does this feature map *inputs to outputs*?

- This is the meat of the work.
- What are the domain rules of the feature you're developing?
- How can you map your input models into the output models?
- You can be as specific as needed in this step.

Are those definitions enough to start developing the feature?

- This is the tricky one. You can be as specific as you want when designing a new feature, it is up to you to decide how abstract your definition can be.
- Thinking of your target audience might help you decide how abstract your design can be. Are you designing this for yourself? Are you designing it for your team and how experienced is your team?

In summary, my approach is *inputs -> core -> output*, those are the three things I need to design before implementing the code itself. Now you might be asking yourself: *How can that concept help me break big implementation tasks into small deliverables?* and my answer to that is *All you need is contracts* (aka data models).

If you know the inputs, core, and outputs, you have a signature for your feature and you have the contracts between whatever will trigger it and whatever will be triggered by it. With those contracts in place, you can break your development into small Lego bricks, since you know how they will be connected in the future to the rest of what you’re building. That is exactly why we have so many protocols in place for a plethora of domains, from USBs to networking and even human interactions themselves. You can apply that same concept to software design, and this is not a new idea at all! You’ve probably heard about concepts such as *Clean Architecture*, *Hexagonal Architecture*, and so on. They all rely on *clear contracts*.

## From contracts to code

Let’s do a design exercise so we can put those concepts into action. Let’s say you want or were assigned to develop the following feature for a financial system:
`The company's financial system has to be able to keep track of transactions between users by using double entries and a ledger`

Let’s start with the most abstract way to represent this feature:

```text
  +-------------------+
  |  new transaction  |
  |      (input)      |
  +---------+---------+
            |
            v
  +-----------------------+
  |  transaction handling |
  |        (core)         |
  +-----------+-----------+
              |
              v
  +---------------------------+
  |  double entry persisted   |
  |         (output)          |
  +---------------------------+
```

From here you can start asking yourself some design questions to understand the *contracts* better:

- What does a transaction input look like? What is the payload? What protocol should we use?
- What does a double entry look like? What do we need to persist? How should we persist that?

You might not have the answers to all those questions right away, but you might be able to answer some of them yourself. If there are still questions left, you can reach out to domain experts/stakeholders to clarify them or research more about the feature yourself.

Let’s say you got some answers for those questions:

- Transactions will be sent via HTTP and the payload is a JSON with credit account, debit account, and amount fields.
- Double entry transactions should be persisted in a relational database with credit account, debit account, amount, datetime of the transaction.

*However, during the investigation you also discovered that you should keep logs of all operations and the entries generated*. Now we can go one step deeper in the abstraction layer.

```text
          +-------------------+
          |  new transaction  |
          +---------+---------+
                    |
                    | transaction contract
                    v
          +-----------------------+
          |  transaction handling |
          +-----+------------+----+
                |            |
                |            | transaction contract
                |            v
                |     +-----------------+
                |     |  log generation |
                |     +--------+--------+
                |              |
                |              | log contract
                |              v
                |     +-----------------+
                |     |  log persisted  |
                |     +-----------------+
                |
                | double entry contract
                v
     +---------------------------+
     |  double entry persisted   |
     +---------------------------+
```

From here you can also try to investigate what the `log contract` looks like and what it should contain.

### Contracts into implementable tasks

Once you figure out the *contracts*, you now have all the connections between the steps of your new feature. Now you know how each step connects to each other and you can create individual and actionable tasks. Clear contracts should also enable parallelization of the implementation, so two pieces of the feature should be able to be implemented at the same time as long as they know how the contracts between them look like.

For the aforementioned example you’d probably end up with a list of tasks similar to this:

- Implement new transaction API (attached the transaction input)
- Implement the double entry persistence layer (attached the double entry input)
- Implement a log generation feature (attached the transaction input)
- Implement a log persistence layer (attached the log input)

## Conclusion

Once you start mapping your new features into *abstract functions* with clear *inputs* and *outputs*, you should have a clear idea of what is still not mapped and how to move forward. You can always go a layer deeper if needed, but it’s up to you to decide when the design is good enough for the implementation phase.

Having clear contracts also enables a design focused on small units of implementation that are less independent from each other. That approach allows better parallelization of work and small more focused *Pull Requests*. All of that reduces the cognitive workload necessary for implementing such tasks, the effort to review them and also the time and complexity to deliver them. A good software design is simple yet complete; it has clear inputs and outputs (contracts); it empowers parallelization of implementation; and it also enables small continuous deliverables.
